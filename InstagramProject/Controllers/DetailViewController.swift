//
//  DetailViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 5/8/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var submitterNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func updateUI() {
        let tempPhoto = photo!
        let url = URL(string: tempPhoto.imageURL)
        detailImageView.kf.setImage(with: url)
    }
    
}
