//
//  DatabaseManager.swift
//  PokemonApp
//
//  Created by JonathanTriC on 14/03/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        return safeEmail
    }
}

//MARK: - Account Management
extension DatabaseManager {
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    /// Insert new user
    public func insertUser(with user: User, completion: @escaping(Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "full_name": user.fullName,
            "email_address": user.emailAddress,
        ]) { error, _ in
            guard error == nil else {
                print("Failed to write to database")
                completion(false)
                return
            }
            
            self.database.child("users").observeSingleEvent(of: .value) { snapshot in
                if var usersCollection = snapshot.value as? [[String: String]] {
                    // append to user dict
                    let newElement = [
                        "fullName": user.fullName,
                        "email": user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    
                    self.database.child("users").setValue(usersCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
                else {
                    // create user dict
                    let newCollection: [[String: String]] = [
                        [
                            "fullName": user.fullName,
                            "email": user.safeEmail
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    }
                }
            }
        }
    }
    
    public func getCurrentUsers(completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        print("currUserEmail: \(currUserEmail)")
        
        var safeEmail = currUserEmail.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        print("currUserEmail safe: \(safeEmail)")

        
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:String] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            
            completion(.success(value))
            
            print("get curr user: \(value)")
        }
    }
        
    // MARK: My Pokemon
    public func addMyPokemon(nickname: String, pokemon: PokemonModel, completion: @escaping(Bool) -> Void) {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        var safeEmail = currUserEmail.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        database.child("my-pokemon-\(safeEmail)").child(nickname).setValue([
            "nickname": nickname,
            "name": pokemon.name as Any,
            "imageUrl": pokemon.imageUrl as Any,
            "type": pokemon.type as Any,
            "weight": pokemon.weight as Any,
            "height": pokemon.height as Any,
            "abilities": pokemon.abilities as Any,
            "moves": pokemon.moves as Any,
        ]) { error, _ in
            guard error == nil else {
                print("Failed to write to database")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    public func getAllMyPokemon(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        var safeEmail = currUserEmail.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        database.child("my-pokemon-\(safeEmail)").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                
                return
            }
                    
            completion(.success(value))
        }
    }
    
    public func getDetailMyPokemon(nickname: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        var safeEmail = currUserEmail.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        database.child("my-pokemon-\(safeEmail)").child(nickname).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                completion(.failure(DatabaseError.failedToFetch))
                
                return
            }
                    
            completion(.success(value))
        }
    }
    
    public func releaseMyPokemon(nickname: String, completion: @escaping(Bool) -> Void) {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        var safeEmail = currUserEmail.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        database.child("my-pokemon-\(safeEmail)").child(nickname).removeValue { error, _ in
            guard error == nil else {
                completion(false)
                print("failed remove value")
                return
            }
            
            print("success remove value")
            completion(true)
        }
    }
    
    public func renameMyPokemon(nickname: String, newNickName:String, completion: @escaping(Bool) -> Void) {
        guard let currUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        
        var safeEmail = currUserEmail.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        database.child("my-pokemon-\(safeEmail)").child(nickname).child("nickname").setValue(newNickName) { error, _ in
            guard error == nil else {
                completion(false)
                print("failed rename value")
                return
            }
            
            print("success rename value")
            completion(true)
        }
    }
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
}

struct User {
    let fullName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "(dot)")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "(at)")
        
        return safeEmail
    }
}
