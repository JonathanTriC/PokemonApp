//
//  MyPokemonViewController.swift
//  PokemonApp
//
//  Created by JonathanTriC on 16/03/23.
//

import UIKit
import JGProgressHUD

class MyPokemonViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Action
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    var myPokemon = [String:Any]()
    var pokemonNickname = [String]()
    let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAllMyPokemon()
    }
    
    func fetchAllMyPokemon() {
        DatabaseManager.shared.getAllMyPokemon { result in
            switch result {
            case .success(let pokemonDict):
                self.myPokemon = pokemonDict
                self.tableView.reloadData()
                print("myPokemon: \(self.myPokemon)")
            case .failure(let error):
                print("Failed to get pokemon list: \(error)")
            }
        }
    }
}

extension MyPokemonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table tapped on: \(self.pokemonNickname[indexPath.row])")
        let vc = UIStoryboard.DetailsVC()
        vc.isFromMyPokemon = true
        vc.pokemonNickname = self.pokemonNickname[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myPokemon.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        for (key,_) in self.myPokemon {
            self.pokemonNickname.append(key)
        }
        cell.textLabel?.text = self.pokemonNickname[indexPath.row]
        
        return cell
    }
    
    
}
