//
//  ViewController.swift
//  InstagramProject
//
//  Created by Matthew Ramos on 3/9/20.
//  Copyright © 2020 Matthew Ramos. All rights reserved.
//

import UIKit
import Firebase


enum AccountState {
    case existingUser
    case newUser
}

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 25
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else {
            infoLabel.text = "Missing text info: Please complete all fields"
            return
        }
        continueLoginFlow(email: email, password: password)
    }
    
    private func continueLoginFlow(email: String, password: String) {
        if accountState == .existingUser {
            authSession.signExistingUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.infoLabel.text = "\(error.localizedDescription)"
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        } else {
            authSession.createNewUser(email: email, password: password) { [weak self] (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let result):
                    DispatchQueue.main.async {
                        self?.createDatabaseUser(authDataResult: result)
                    }
                }
            }
        }
    }
    
    private func createDatabaseUser(authDataResult: AuthDataResult) {
      DatabaseService.shared.createDatabaseUser(authDataResult: authDataResult, imageURL: nil ) { [weak self] (result) in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            self?.showAlert(title: "Account Error", message: error.localizedDescription)
          }
        case .success:
          DispatchQueue.main.async {
            self?.navigateToMainView()
          }
        }
      }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerId: "TabBarController")
    }
    
    private func clearErrorLabel() {
        infoLabel.text = ""
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        accountState = accountState == .existingUser ? .newUser : .existingUser
//        let duration: TimeInterval = 1.0
        if accountState == .existingUser {
            logInButton.setTitle("Log In", for: .normal)
            navigationItem.title = "Log In"
//            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
//                self.loginButton.setTitle("Login", for: .normal)
//                self.accountStateMessageLabel.text = "Don't have an account ? Click"
//                self.accountStateButton.setTitle("SIGNUP", for: .normal)
//            }, completion: nil)
        } else {
            logInButton.setTitle("Sign Up", for: .normal)
            navigationItem.title = "Sign Up"
//            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
//                self.loginButton.setTitle("Sign Up", for: .normal)
//                self.accountStateMessageLabel.text = "Already have an account ?"
//                self.accountStateButton.setTitle("LOGIN", for: .normal)
//            }, completion: nil)
        }
    }
}

