//
//  User.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/27/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

class User: NSObject, NSCoding, JSONDecodable {
    
    let name: String?
    let username: String?
    
    init(name:String?, username:String?) {
        self.name = name == "" ? nil : name
        self.username = name == "" ? nil : username
    }
    
    required init(json: JSON) throws {
        let name = json["nombre"].stringValue
        let username = json["usuario"].stringValue
        self.name = name == "" ? nil : name
        self.username = username == "" ? nil : username
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        self.init(name: name, username: username)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(username, forKey: "username")
    }
    
}

class Credential: JSONDecodable{
    let result: Bool
    
    required init(json: JSON) throws {
        self.result = json["resultado"].boolValue
    }
}
