//
//  Lost.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/8/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

class Categories: JSONDecodable {
    let lostCategories: [LostCategory]?
    
    init(lostCategories: [LostCategory]?) {
        self.lostCategories = lostCategories
    }
    //{categorias: [{nombre:1, perdidos: []}, {nombre:2, pedidos: []}]}
    required init(json: JSON) throws {
        var _lostCategories: [LostCategory] = []
        for (_,category) in json["categorias"] {
            let category = try LostCategory(json: category)
            print(category.name)
            _lostCategories.append(category)
        }
        self.lostCategories = _lostCategories
    }
}

class LostCategory: JSONDecodable {
    
    let name: String
    let lostArray: [Lost]?
    
    init(name: String, lostArray: [Lost]?) {
        self.name = name
        self.lostArray = lostArray
    }
    //{categoria: "", perdidos: [{uno},{dos}]}
    required init (json: JSON) throws {
        self.name = json["nombre"].stringValue
        var _lostArray: [Lost] = []
        for (_,lost) in json["perdidos"] {
            let lost = try Lost(json: lost)
            _lostArray.append(lost)
        }
        self.lostArray = _lostArray
    }
}

class Lost: JSONDecodable{
    
    let firstname: String
    let lastname: String
    let dni: String
    let age: Int
    let description: String
    let imageUrl: String

    init(firstname: String, lastname: String, dni: String, age: Int, description: String, base64ImageStr: String = "") {
        self.firstname = firstname
        self.lastname = lastname
        self.dni = dni
        self.age = age
        self.description = description
        self.imageUrl = base64ImageStr
        let str = self.imageUrl.replacingOccurrences(of: "data:image/jpeg;base64,", with: "")
    }
    
    required init(json: JSON) throws {
        self.firstname = json["nombre"].stringValue
        self.lastname = json["apellido"].stringValue
        self.dni = json["dni"].stringValue
        self.age = json["age"].intValue
        self.description = json["description"].stringValue
        self.imageUrl = json["imagen"].stringValue
    }
}
