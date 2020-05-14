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
                      "profilePhoto": imageURL?.absoluteString ?? "", "uploadCount": 0]) { (error) in
                        
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
        }
    }
    
    public func fetchDatabaseUser(completion: @escaping (Result <User, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.usersCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let snapshot = snapshot {
                guard let result = snapshot.data() else {
                    return
                }
                let user = User(email: result["email"] as! String, createdDate: result["createdDate"] as! Timestamp, userId: result["userId"] as! String, profilePhoto: result["profilePhoto"] as! String, uploadCount: result["uploadCount"] as! Int)
                
                completion(.success(user))
            }
        }
    }
    
    
}
