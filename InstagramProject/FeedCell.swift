//
//  FeedCell.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/15/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher

class FeedCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var cellPhoto: Photo?
    
    
    func configureCell(photo: Photo) {
        let url = URL(string: photo.imageURL)
        userNameLabel.text = "Posted by \(photo.createdBy)"
        photoImageView.kf.setImage(with: url)
        cellPhoto = photo
    }
    
}
