//
//  PokemonModel.swift
//  PokemonApp
//
//  Created by JonathanTriC on 15/03/23.
//

import Foundation

class PokemonModel{
    var id: Int?
    var nickname: String?
    var name: String?
    var imageUrl: String?
    var weight: Int?
    var height: Int?
    var type: String?
    var baseExperience: Int?
    var abilities: String?
    var moves: String?
    
    init(dictionary: [String: AnyObject]){
        if let nickname = dictionary["nickname"] as? String{
            self.nickname = nickname
        }
        if let name = dictionary["name"] as? String{
            self.name = name
        }
        if let imageUrl = dictionary["imageUrl"] as? String{
            self.imageUrl = imageUrl
        }
        if let weight = dictionary["weight"] as? Int{
            self.weight = weight
        }
        if let height = dictionary["height"] as? Int{
            self.height = height
        }
        if let type = dictionary["type"] as? String{
            self.type = type
        }
        if let baseExperience = dictionary["baseExperience"] as? Int{
            self.baseExperience = baseExperience
        }
        if let abilities = dictionary["abilities"] as? String{
            self.abilities = abilities
        }

        if let moves = dictionary["moves"] as? String{
            self.moves = moves
        }
    }
}
