//
//  Extension.swift
//  PokemonApp
//
//  Created by JonathanTriC on 15/03/23.
//

import UIKit

extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        if self.image == nil{
            self.image = UIImage(systemName: "person.fill")
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
}

extension Dictionary {
    func toJson()->String{
        let dictionary = self
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: dictionary,
            options: .prettyPrinted
        ),
           let theJSONText = String(data: theJSONData, encoding:  String.Encoding.ascii) {
            return theJSONText
        }
        return ""
    }
}
