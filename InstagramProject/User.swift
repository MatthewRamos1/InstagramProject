//
//  User.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/13/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import Firebase

class User {
    var email: String
    var createdDate: Timestamp
    var userId: String
    var profilePhoto: String
    var uploadCount: Int
    
    init(email: String, createdDate: Timestamp, userId: String, profilePhoto: String, uploadCount: Int) {
        self.email = email
        self.createdDate = createdDate
        self.userId = userId
        self.profilePhoto = profilePhoto
        self.uploadCount = uploadCount
    }
    
}
