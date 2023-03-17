//
//  Route.swift
//  PokemonApp
//
//  Created by JonathanTriC on 14/03/23.
//

import UIKit

extension UIStoryboard {
    class func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    class func MainVC() -> ViewController {
        return UIStoryboard.main().instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    
    class func login() -> UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    class func LoginVC() -> LoginViewController {
        return UIStoryboard.login().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    class func register() -> UIStoryboard{
        return UIStoryboard(name: "Register",bundle: nil)
    }
    
    class func RegisterVC() -> RegisterViewController {
        return  UIStoryboard.register().instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
    }
    
    class func details() -> UIStoryboard {
        return UIStoryboard(name: "Details", bundle: nil)
    }
    
    class func DetailsVC() -> DetailsViewController {
        return UIStoryboard.details().instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
    }
    
    class func myPokemon() -> UIStoryboard {
        return UIStoryboard(name: "MyPokemon", bundle: nil)
    }
    
    class func MyPokemonVC() -> MyPokemonViewController {
        return UIStoryboard.myPokemon().instantiateViewController(withIdentifier: "MyPokemonViewController") as! MyPokemonViewController
    }
}
