//
//  ProfileViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 3/10/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher
import AVFoundation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uploadCountLabel: UILabel!
    
    private var imagePickerController = UIImagePickerController()
    private var currentUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        getDatabaseUser()
//        profileNameTextField.isUserInteractionEnabled = false
        
    }
    
    private func updateUI() {
        guard let user = currentUser else {
            return
        }
        emailLabel.text = user.email
        profileNameTextField.text = user.userName
        uploadCountLabel.text = "Number of uploads: \(String(user.uploadCount))"
        print(user.profilePhoto)
        let url = URL(string: user.profilePhoto)
        profileImageView.kf.setImage(with: url)
        
    }
    
    private func getDatabaseUser() {
        DatabaseService.shared.fetchDatabaseUser { [weak self] (result) in
            switch result {
            case .failure:
                return
            case .success(let user):
                DispatchQueue.main.async {
                    self?.currentUser = user
                    self?.updateUI()
                }
            }
        }
    }
    
    @IBAction func addProfilePicturePressed(_ sender: UIButton) {
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
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let image = profileImageView.image!
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let resizeImage = image.resizeImage(to: rect.size.width, height: rect.size.height)
        StorageService.shared.createPhoto(storageType: .user, id: currentUser!.userId, image: resizeImage) { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Couldn't store photo: \(error.localizedDescription)")
            case .success(let url):
                guard let newUser = self?.currentUser, let userName = self?.profileNameTextField.text else {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Missing Info", message: "Couldn't get username")
                    }
                    return
                }
                let user = User(email: newUser.email, createdDate: newUser.createdDate, userName: userName, userId: newUser.userId, profilePhoto: url.absoluteString, uploadCount: newUser.uploadCount)
                DatabaseService.shared.updateDatabaseUser(user: user)
            }
            
        }
    }
    
    private func showImageController(isCameraSelected: Bool) {
        imagePickerController.sourceType = .photoLibrary
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
                return
        }
        
        profileImageView.image = image
        currentUser?.profilePhoto = imageURL.absoluteString
        DatabaseService.shared.updateDatabaseUser(user: currentUser!)
        dismiss(animated: true)
        
        
    }
    
}

