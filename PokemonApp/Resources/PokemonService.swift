//
//  PokemonService.swift
//  PokemonApp
//
//  Created by JonathanTriC on 15/03/23.
//

import PokemonAPI

class PokemonService {
    static let shared = PokemonService()
    
    func fetchAllPokemon(completion: @escaping([PokemonModel]) -> ()) {
        var pokemons = [PokemonModel]()
        for id in 1...50 {
            PokemonAPI().pokemonService.fetchPokemon(id) { result in
                switch result {
                case .success(let pokeResult):
                    let dictionary: [String: AnyObject] = [
                        "name": pokeResult.name as AnyObject,
                        "weight": pokeResult.weight as AnyObject,
                        "height": pokeResult.height as AnyObject,
                        "baseExperience": pokeResult.baseExperience as AnyObject,
                        "imageUrl": pokeResult.sprites?.frontDefault as AnyObject,
                        "type": pokeResult.types?.first?.type?.name as AnyObject,
                        "abilities": pokeResult.abilities?.first?.ability?.name as AnyObject,
                        "moves": pokeResult.moves?.first?.move?.name as AnyObject
                    ]
                    let pokemon = PokemonModel(dictionary: dictionary)
                    pokemons.append(pokemon)
                    
                    completion(pokemons)
                case .failure(let error):
                    print("failed fetch pokemon: \(error)")
                }
            }
        }
    }
    
    func fetchPokemonDetails(name: String, completion: @escaping(PokemonModel) -> ()){
        PokemonAPI().pokemonService.fetchPokemon(name) { result in
            switch result {
            case .success(let pokeResult):
                let dictionary: [String: AnyObject] = [
                    "name": pokeResult.name as AnyObject,
                    "weight": pokeResult.weight as AnyObject,
                    "height": pokeResult.height as AnyObject,
                    "baseExperience": pokeResult.baseExperience as AnyObject,
                    "imageUrl": pokeResult.sprites?.frontDefault as AnyObject,
                    "type": pokeResult.types?.first?.type?.name as AnyObject,
                    "abilities": pokeResult.abilities?.first?.ability?.name as AnyObject,
                    "moves": pokeResult.moves?.first?.move?.name as AnyObject
                ]
                let pokemon = PokemonModel(dictionary: dictionary)
                
                completion(pokemon)
            case .failure(let error):
                print("failed fetch pokemon details: \(error)")
            }
        }
    }
}
