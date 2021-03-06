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
    var createdBy: String
    var createdDate: String
    
    init(photoId: String, imageURL: String, createdBy: String, createdDate: String) {
        self.photoId = photoId
        self.imageURL = imageURL
        self.createdBy = createdBy
        self.createdDate = createdDate
    }
    
    init(_ dictionary: [String: Any]) {
        self.photoId = dictionary["photoId"] as? String ?? "No id"
        self.imageURL = dictionary["imageURL"] as? String ?? "No id"
        self.createdBy = dictionary["createdBy"] as? String ?? "No username"
        self.createdDate = dictionary["createdDate"] as? String ?? ""
    }
}
