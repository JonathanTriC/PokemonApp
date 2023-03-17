//
//  DetailsViewController.swift
//  PokemonApp
//
//  Created by JonathanTriC on 16/03/23.
//

import UIKit
import JGProgressHUD

class DetailsViewController: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var pokemonNameLbl: UILabel!
    @IBOutlet weak var pokemonTypeLbl: UILabel!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonWeightLbl: UILabel!
    @IBOutlet weak var pokemonHeightLbl: UILabel!
    @IBOutlet weak var pokemonAbilityLbl: UILabel!
    @IBOutlet weak var pokemonMoveLbl: UILabel!
    @IBOutlet weak var whRow: UIStackView!
    @IBOutlet weak var amRow: UIStackView!
    @IBOutlet weak var catchBtn: UIButton!
    @IBOutlet weak var renameBtn: UIButton!
    
    // MARK: Action
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func catchPokemon(_ sender: UIButton) {
        if isFromMyPokemon {
            onRelease()
        } else {
            onCatch()
        }
    }
    @IBAction func renamePokemon(_ sender: UIButton) {
        print("rename")
        alertRenamePokemon()
    }
    
    let spinner = JGProgressHUD(style: .dark)
    
    var pokemonName = ""
    var pokemonNickname = ""
    var newPokemonNickname = ""
    var pokemonModel: PokemonModel?
    var isFromMyPokemon: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.show(in: view)
        hideShowView(true)
        self.renameBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromMyPokemon {
            print("pokemon nickname: \(pokemonNickname)")
            self.catchBtn.setTitle("Release Pokemon", for: .normal)
            self.catchBtn.backgroundColor = .red
            fetchDetailMyPokemon(pokemonNickname)
        } else {
            print("pokemon name: \(pokemonName)")
            self.catchBtn.setTitle("Catch Pokemon", for: .normal)
            self.catchBtn.backgroundColor = .link
            fetchPokemon(pokemonName)
        }
    }
    
    func hideShowView(_ isHide: Bool) {
        self.pokemonNameLbl.isHidden = isHide
        self.pokemonImg.isHidden = isHide
        self.pokemonTypeLbl.isHidden = isHide
        self.whRow.isHidden = isHide
        self.amRow.isHidden = isHide
        self.catchBtn.isHidden = isHide
    }
    
    func fetchPokemon(_ pokemonName: String) {
        PokemonService.shared.fetchPokemonDetails(name: pokemonName) { pokemon in
            DispatchQueue.main.async {
                print("pokemon detail name: \(String(describing: pokemon.name))")
                
                self.hideShowView(false)
                self.renameBtn.isHidden = true
                self.pokemonModel = pokemon
                self.pokemonNameLbl.text = pokemon.name?.capitalized
                self.pokemonImg.imageFromURL(urlString: pokemon.imageUrl ?? "")
                self.pokemonWeightLbl.text = "\((pokemon.weight ?? 0) / 10) kg"
                self.pokemonHeightLbl.text = "\((pokemon.height ?? 0) * 10) cm"
                self.pokemonTypeLbl.text = "Type: \(pokemon.type ?? "")"
                self.pokemonAbilityLbl.text = "\(pokemon.abilities ?? "")"
                self.pokemonMoveLbl.text = "\(pokemon.moves ?? "")"
                
                self.spinner.dismiss()
            }
        }
    }
    
    func fetchDetailMyPokemon(_ nickname: String) {
        DatabaseManager.shared.getDetailMyPokemon(nickname: nickname) { result in
            switch result {
            case .success(let pokemonDict):
                print("get detail pokemon nickname: \(String(describing: pokemonDict["nickname"]))")
                self.hideShowView(false)
                self.renameBtn.isHidden = false
                self.pokemonNameLbl.text = "\(pokemonDict["nickname"] ?? "")"
                self.pokemonImg.imageFromURL(urlString: "\(pokemonDict["imageUrl"] ?? "")")
                self.pokemonWeightLbl.text = "\((pokemonDict["weight"] as? Int ?? 0) / 10) kg"
                self.pokemonHeightLbl.text = "\((pokemonDict["height"] as? Int ?? 0) * 10) cm"
                self.pokemonTypeLbl.text = "Type: \(pokemonDict["type"] ?? "")"
                self.pokemonAbilityLbl.text = "\(pokemonDict["abilities"] ?? "")"
                self.pokemonMoveLbl.text = "\(pokemonDict["moves"] ?? "")"
                
                self.spinner.dismiss()
            case .failure(let error):
                print("Failed to get pokemon detail: \(error)")
            }
        }
    }
    
    func onCatch() {
        // Get probability 50%
        // if 1 get pokemon
        // if 0 not get pokemon
        let randomZeroOne = arc4random_uniform(2)
        print("probability is: \(randomZeroOne)")
        
        if randomZeroOne == 1 {
            // Get Pokemon
            print("catch")
            alertCatchPokemon(isCatch: true){ action in
                print("navigate")
            }
        } else {
            print("cant catch pokemon")
            alertCatchPokemon(isCatch: false, title: "Oops!", message: "Sorry you're not catching the pokemon, please try again") { action in
                return
            }
        }
    }
    
    func onRelease() {
        // random number and check if prime number
        let i = Int.random(in: 0...50)

        func isPrime(_ number: Int) -> Bool {
            return number > 1 && !(2..<number).contains {
                number % $0 == 0
            }
        }

        print(i)
        print(isPrime(i))
        if isPrime(i) {
            // success release pokemon
            print("release success")
            alertReleasePokemon(isRelease: true) { action in
            }
        } else {
            // fail release pokemon
            print("release fail")
            alertReleasePokemon(isRelease: false, title: "Oops!", message: "Sorry you're not releasing the pokemon, please try again") { action in
                return
            }
        }
    }
    
    func alertCatchPokemon(
        isCatch: Bool,
        title: String = "Yeay!",
        message: String = "You successfuly catch the pokemon, go make your own nicknames",
        handler: @escaping ((UIAlertAction) -> Void))
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if isCatch {
            alert.addTextField()
            let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
                let answer = alert.textFields![0]
                guard let model = self.pokemonModel else {
                    return
                }
                
                DatabaseManager.shared.addMyPokemon(
                    nickname: answer.text ?? "",
                    pokemon: model)
                { success in
                    print("success add pokemon")
                }
            }
            
            alert.addAction(submitAction)
        } else {
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: handler))
        }
        
        present(alert, animated: true)
    }
    
    func alertRenamePokemon() {
        let alert = UIAlertController(title: "Rename Your Pokemon",
                                      message: "Insert new nickname for your pokemon",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alert] _ in
            let answer = alert.textFields![0]
            DatabaseManager.shared.renameMyPokemon(nickname: self.pokemonNickname, newNickName: answer.text ?? "") { success in
                print("success rename pokemon")
            }
        }
        
        alert.addAction(submitAction)
        present(alert, animated: true)
    }
    
    func alertReleasePokemon(
        isRelease: Bool,
        title: String = "Yeay!",
        message: String = "You successfuly release the pokemon, go collect more pokemon",
        handler: @escaping ((UIAlertAction) -> Void))
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if isRelease {
            let releaseAction = UIAlertAction(title: "Release", style: .default) { _ in
                DatabaseManager.shared.releaseMyPokemon(nickname: self.pokemonNickname) { success in
                    print("remove")
                }
            }
            
            alert.addAction(releaseAction)
        } else {
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: handler))
        }
        
        present(alert, animated: true)
    }
}
