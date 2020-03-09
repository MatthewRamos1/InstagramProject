//
//  ViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 3/9/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit

enum AccountState {
    case existingUser
    case newUser
}

class ViewController: UIViewController {
    
    
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

