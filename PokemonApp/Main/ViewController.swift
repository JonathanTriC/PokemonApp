//
//  ViewController.swift
//  PokemonApp
//
//  Created by JonathanTriC on 14/03/23.
//

import UIKit
import FirebaseAuth
import PokemonAPI
import JGProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var pokemons = [PokemonModel]()
    
    let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.show(in: view)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getPokemonList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        validateUserAuth()
    }
        
    func validateUserAuth() {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        print("currUserEmail: \(currUserEmail)")
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            print("please log in")
            let vc = UIStoryboard.LoginVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    
    func getPokemonList() {
        PokemonService.shared.fetchAllPokemon { pokemons in
            DispatchQueue.main.async {
                self.pokemons = pokemons
                self.tableView.reloadData()
                self.spinner.dismiss()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.DetailsVC()
        vc.isFromMyPokemon = false
        vc.pokemonName = pokemons[indexPath.row].name ?? ""
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pokemons[indexPath.row].name
        cell.imageView?.imageFromURL(urlString: pokemons[indexPath.row].imageUrl ?? "")
        
        return cell
    }
}
