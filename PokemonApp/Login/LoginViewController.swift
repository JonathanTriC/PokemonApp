//
//  LoginViewController.swift
//  PokemonApp
//
//  Created by JonathanTriC on 15/03/23.
//

import Foundation
import UIKit
import JGProgressHUD
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    // MARK: Action
    @IBAction func loginBtn(_ sender: UIButton) {
        onLogin()
    }
    
    @IBAction func goToRegisterBtn(_ sender: UIButton) {
        print("go to register")
        let vc = UIStoryboard.RegisterVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    func onLogin() {
        print("click login")

        guard let email = emailTF.text,
              let password = passwordTF.text,
              !email.isEmpty,
              !password.isEmpty
        else {
            alertUserLoginError()
            return
        }

        spinner.show(in: view)

        // Login Firebase
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }

            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }

            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                strongSelf.alertUserLoginError(message: "Wrong email or password! Please try again with the correct credential.")
                return
            }

            let user = result.user

            UserDefaults.standard.set(email, forKey: "email")

            print("Logged In User: \(user.email ?? "")")
            strongSelf.dismiss(animated: true)
        }
    }
    
    func alertUserLoginError(message: String = "Please enter all information to log in") {
        let alert = UIAlertController(title: "Whoops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            passwordTF.resignFirstResponder()
            onLogin()
        }

        return true
    }
}
