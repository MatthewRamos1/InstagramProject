//
//  UploadImageViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class UploadImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        getDatabaseUser()
        
    }
    
    private func getDatabaseUser() {
        DatabaseService.shared.fetchDatabaseUser { [weak self] (result) in
            switch result {
            case .failure(let error):
                fatalError("Couldn't get user: \(error.localizedDescription)")
            case .success(let user):
                DispatchQueue.main.async {
                    self?.currentUser = user
                }
            }
        }
    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool) {
        imagePickerController.sourceType = .photoLibrary
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
    @IBAction func uploadPhoto(_ sender: UIButton) {
        guard let image = imageView.image else {
            fatalError("Couldn't get image")
        }
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        let id = UUID().uuidString
        StorageService.shared.createPhoto(storageType: .photo, id: id, image: resizeImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Couldn't store photo: \(error.localizedDescription)")
                }
            case .success(let url):
                DatabaseService.shared.createDatabasePhoto(id: id, imageURL: url, createdBy: self?.currentUser?.userName ?? "Unknown User") {  (result) in
                    switch result {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error", message: "Couldn't store photo info: \(error.localizedDescription)")
                        }
                    case .success:
                        self?.currentUser?.uploadCount += 1
                        guard let user = self?.currentUser else {
                            fatalError("Couldn't get user")
                        }
                        DatabaseService.shared.updateDatabaseUser(user: user)
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Success", message: "Photo was posted")
                        }
                    }
                }
            }
        }
    }
}

extension UploadImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        imageView.image = image
        dismiss(animated: true)
    }
}
