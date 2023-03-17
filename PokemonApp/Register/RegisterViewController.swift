//
//  RegisterViewController.swift
//  PokemonApp
//
//  Created by JonathanTriC on 14/03/23.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class RegisterViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var regisEmailTF: UITextField!
    @IBOutlet weak var regisPassTF: UITextField!
    
    // MARK: Action
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func registerBtn(_ sender: UIButton) {
        onRegister()
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullNameTF.delegate = self
        regisEmailTF.delegate = self
        regisPassTF.delegate = self
    }
    
    func onRegister() {
        print("clik regist")
        
        guard let fullname = fullNameTF.text,
              let email = regisEmailTF.text,
              let password = regisPassTF.text,
              !fullname.isEmpty,
              !email.isEmpty,
              !password.isEmpty
        else {
            alertUserRegisterError()
            return
        }
        
        spinner.show(in: view)
        
        // Register Firebase
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard !exists else {
                // user already exist
                strongSelf.alertUserRegisterError(message: "Email is already exits..")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
                guard authResult != nil, error == nil else {
                    strongSelf.alertUserRegisterError(message: "Email is already exits..")
                    print("Error creating user")
                    return
                }
                
                let user = User(fullName: fullname, emailAddress: email)
                
                DatabaseManager.shared.insertUser(with: user) { success in
                    if success {
                        UserDefaults.standard.set(email, forKey: "email")
                        print("success insert user")
                    }
                }
                
                strongSelf.dismiss(animated: true)
            }
        }
    }
    
    func alertUserRegisterError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Whoops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTF {
            regisEmailTF.becomeFirstResponder()
        } else if textField == regisEmailTF {
            regisPassTF.becomeFirstResponder()
        } else {
            regisPassTF.resignFirstResponder()
            onRegister()
        }
        
        return true
    }
}
