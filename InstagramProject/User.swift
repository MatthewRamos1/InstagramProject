//
//  User.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/13/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import Firebase

class User: Codable {
    var email: String
    var createdDate: String
    var userName: String
    var userId: String
    var profilePhoto: String
    var uploadCount: Int
    
    init(email: String, createdDate: String, userName: String, userId: String, profilePhoto: String, uploadCount: Int) {
        self.email = email
        self.createdDate = createdDate
        self.userName = userName
        self.userId = userId
        self.profilePhoto = profilePhoto
        self.uploadCount = uploadCount
    }
    
    init(_ dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? "No email"
        self.createdDate = dictionary["createdDate"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? "profileName"
        self.userId = dictionary["userId"] as? String ?? "No user ID"
        self.profilePhoto = dictionary["profilePhoto"] as? String ?? ""
        self.uploadCount = dictionary["uploadCount"] as? Int ?? 0
    }
    
}
