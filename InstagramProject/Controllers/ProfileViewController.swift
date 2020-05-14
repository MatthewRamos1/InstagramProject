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

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var uploadCountLabel: UILabel!
    
    private var imagePickerController = UIImagePickerController()
    private var currentUser: User?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        getDatabaseUser()
        
    }
    
    private func updateUI() {
        guard let user = currentUser else {
            return
        }
        emailLabel.text = user.email
        uploadCountLabel.text = "Number of uploads: \(String(user.uploadCount))"
        
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
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        profileImageView.image = image
        dismiss(animated: true)
        
        
    }
    
}

