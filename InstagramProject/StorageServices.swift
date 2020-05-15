//
//  StorageServices.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/14/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import FirebaseStorage

enum StorageType{
    case user
    case photo
}

class StorageService {
    
    private let storageRef = Storage.storage().reference()
    
    private init() {}
    static let shared = StorageService()
    
    public func createPhoto(storageType: StorageType, id: String, image: UIImage, completion: @escaping (Result<URL,Error>) -> ()) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        var photoReference: StorageReference!
        
        switch storageType {
        case .user:
            photoReference = storageRef.child("UserProfilePhotos/\(id).jpg")
        case.photo:
            photoReference = storageRef.child("UserFeedPhotos/\(id).jpg")
        }
      
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let _ = photoReference.putData(imageData, metadata: metadata) { (metadata, error) in
            
            if let error = error {
                completion(.failure(error))
            } else if let _ = metadata {
                photoReference.downloadURL { (url, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else if let url = url {
                        completion(.success(url))
                    }
                }
            }
        }
    }
    
    
}
