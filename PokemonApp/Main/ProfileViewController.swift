//
//  ProfileViewController.swift
//  PokemonApp
//
//  Created by JonathanTriC on 15/03/23.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ProfileViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var myPokemonRow: UIStackView!
    @IBOutlet weak var logOutRow: UIStackView!
    
    // MARK: Action
    @IBAction func logOutBtn(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            UserDefaults.standard.set("", forKey: "email")
            
            let vc = UIStoryboard.LoginVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
        catch {
            print("Failed to log out")
        }
    }
    
    @IBAction func myPokemonBtn(_ sender: UIButton) {
        print("nav to list")
        let vc = UIStoryboard.MyPokemonVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)

    }
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameLbl.isHidden = true
        emailLbl.isHidden = true
        avatar.isHidden = true
        myPokemonRow.isHidden = true
        logOutRow.isHidden = true

        spinner.show(in: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
    }
    
    func fetchUser() {
        DatabaseManager.shared.getCurrentUsers { result in
            switch result {
            case .success(let userDict):
                print("user dict: \(userDict)")
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                
                self.fullNameLbl.isHidden = false
                self.emailLbl.isHidden = false
                self.avatar.isHidden = false
                self.myPokemonRow.isHidden = false
                self.logOutRow.isHidden = false
                
                self.fullNameLbl.text = userDict["full_name"]
                self.emailLbl.text = userDict["email_address"]
            case .failure(let error):
                print("Failed to get users: \(error)")
            }
        }
    }
}
