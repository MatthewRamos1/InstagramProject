//
//  PostFeedViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

class PostFeedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

    }

}

extension PostFeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}

extension PostFeedViewController: UICollectionViewDelegate {
    
}
