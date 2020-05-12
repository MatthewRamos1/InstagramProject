//
//  DatabaseServices.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/12/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class DatabaseService {
    static let usersCollection = "users"
    static let photoCollection = "photos"
    
    private let db = Firestore.firestore()
    
    private init() {}
    static let shared = DatabaseService()
}

