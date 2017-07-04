//
//  User.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/27/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    
    let name: String
    let username: String
    let age: Int?
    let email: String?
    let dni: String?
    
    init(name:String, username:String, age: Int = 0, email: String = "", dni: String = "")  {
        self.name = name
        self.username = username
        self.age = age
        self.email = email
        self.dni = dni
    }
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String ?? dictionary["nombre"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? dictionary["usuario"] as? String ?? ""
        self.age = dictionary["edad"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.dni = dictionary["dni"] as? String ?? ""
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        let age = aDecoder.decodeObject(forKey: "age") as! Int
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let dni = aDecoder.decodeObject(forKey: "dni") as! String
        self.init(name: name, username: username, age: age, email: email, dni: dni)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(age, forKey: "age")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(dni, forKey: "dni")
    }
    
}
