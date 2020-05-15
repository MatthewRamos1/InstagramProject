//
//  Photo.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/15/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation

class Photo {
    var photoId: String
    var imageURL: String
    
    init(photoId: String, imageURL: String) {
        self.photoId = photoId
        self.imageURL = imageURL
    }
    
    init(_ dictionary: [String: Any]) {
        self.photoId = dictionary["photoId"] as? String ?? "No id"
        self.imageURL = dictionary["imageURL"] as? String ?? "No id"
    }
}
