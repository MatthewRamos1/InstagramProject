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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    
    
    private var accountState: AccountState = .existingUser
    private var authSession = AuthenticationSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
//                        self?.errorLabel.text = "\(error.localizedDescription)"
//                        self?.errorLabel.textColor = .red
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
                    DispatchQueue.main.async {
//                        self?.errorLabel.text = "\(error.localizedDescription)"
//                        self?.errorLabel.textColor = .red
                    }
                case .success:
                    DispatchQueue.main.async {
                        self?.navigateToMainView()
                    }
                }
            }
        }
    }
    
    private func navigateToMainView() {
        UIViewController.showViewController(storyboardName: "MainView", viewControllerId: "MainTabBarController")
    }
    
    private func clearErrorLabel() {
        infoLabel.text = ""
    }
    
    @IBAction func toggleAccountState(_ sender: UIButton) {
        accountState = accountState == .existingUser ? .newUser : .existingUser
//        let duration: TimeInterval = 1.0
        if accountState == .existingUser {
            logInButton.setTitle("Log In", for: .normal)
//            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
//                self.loginButton.setTitle("Login", for: .normal)
//                self.accountStateMessageLabel.text = "Don't have an account ? Click"
//                self.accountStateButton.setTitle("SIGNUP", for: .normal)
//            }, completion: nil)
        } else {
            logInButton.setTitle("Sign Up", for: .normal)
//            UIView.transition(with: containerView, duration: duration, options: [.transitionCrossDissolve], animations: {
//                self.loginButton.setTitle("Sign Up", for: .normal)
//                self.accountStateMessageLabel.text = "Already have an account ?"
//                self.accountStateButton.setTitle("LOGIN", for: .normal)
//            }, completion: nil)
        }
    }
}
