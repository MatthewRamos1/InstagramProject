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
    
    var photo: Photo!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        let url = URL(string: photo.imageURL)
        submitterNameLabel.text = photo.createdBy
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
//        let date = dateFormatter.date(from: photo.createdDate)
        createdAtLabel.text = photo.createdDate
        detailImageView.kf.setImage(with: url)
    }
    
}
