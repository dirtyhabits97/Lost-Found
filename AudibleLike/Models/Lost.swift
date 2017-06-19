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
import MapKit

class Categories {
    let lostCategories: [LostCategory]?
    
    init(lostCategories: [LostCategory]?) {
        self.lostCategories = lostCategories
    }
    init(dictionary: [String:Any]) {
        var _lostCategories: [LostCategory] = []
        if let dictionaries = dictionary["categorias"] as? [[String:Any]] {
            for dict in dictionaries {
                let category = LostCategory(dictionary: dict)
                _lostCategories.append(category)
            }
        }
        self.lostCategories = _lostCategories
    }
}

class LostCategory {
    
    let name: String
    let lostArray: [Lost]?
    
    init(name: String, lostArray: [Lost]?) {
        self.name = name
        self.lostArray = lostArray
    }
    init(dictionary: [String:Any]) {
        var _lostArray: [Lost] = []
        self.name = dictionary["nombre"] as? String ?? ""
        if let dictionaries = dictionary["perdidos"] as? [[String:Any]] {
            for dict in dictionaries {
                let lost = Lost(dictionary: dict)
                _lostArray.append(lost)
            }
        }
        self.lostArray = _lostArray
    }
}

class Lost {
    
    let firstname: String
    let lastname: String
    let dni: String
    let age: Int
    let description: String
    let imageUrl: String
    let longitude: Double
    let latitude: Double

    init(firstname: String, lastname: String, dni: String, age: Int, description: String, imageUrl: String = "", longitude: Double = 0, latitude: Double = 0) {
        self.firstname = firstname
        self.lastname = lastname
        self.dni = dni
        self.age = age
        self.description = description
        self.imageUrl = imageUrl
        self.latitude = latitude//-12.0854081
        self.longitude = longitude//-76.9719187
    }
    init(dictionary: [String:Any]) {
        self.firstname = dictionary["nombre"] as? String ?? ""
        self.lastname = dictionary["apellido"] as? String ?? ""
        self.dni = dictionary["dni"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.description = dictionary["description"] as? String ?? ""
        self.imageUrl = dictionary["imagen"] as? String ?? ""
        self.longitude = dictionary["longitud"] as? Double ?? 0
        self.latitude = dictionary["latitud"] as? Double ?? 0
    }
}

class LostAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
