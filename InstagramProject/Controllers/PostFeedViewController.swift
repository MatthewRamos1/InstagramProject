//
//  PostFeedViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var feedListener: ListenerRegistration?
    
    var photos = [Photo]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        feedListener?.remove()
    }
    
    private func setListener() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        feedListener = Firestore.firestore().collection(DatabaseService.usersCollection).document(user.uid).collection(DatabaseService.photoCollection).addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error getting photos", message: "\(error.localizedDescription)")
                }
            } else if let snapshot = snapshot {
                let photoData = snapshot.documents.map { $0.data() }
                self?.photos = photoData.map { Photo($0)}
            }
            
        }
    }
    
}


extension PostFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedCell", for: indexPath) as? FeedCell else {
            fatalError("Couldn't downcast to FeedCell")
        }
        let photo = photos[indexPath.row]
        cell.configureCell(photo: photo)
        return cell
    }
    
    
}

extension PostFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}
