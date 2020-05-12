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
    
    public func createDatabaseUser(authDataResult: AuthDataResult, imageURL: URL?, completion: @escaping (Result<Bool, Error>) -> ()) {
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.usersCollection)
            .document(authDataResult.user.uid)
            .setData(["email" : email,
                      "createdDate": Timestamp(date: Date()),
                      "userId": authDataResult.user.uid,
                      "profilePhoto": imageURL?.absoluteString ?? ""]) { (error) in
                        
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
        }
    }
    
}
