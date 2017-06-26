//
//  Lost.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/8/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation
import MapKit

class Categories {
    let lostCategories: [LostCategory]?
    
    init(lostCategories: [LostCategory]?) {
        self.lostCategories = lostCategories
    }
    init(dictionary: [String:Any]) {
        var _lostCategories: [LostCategory] = []
        if let dictionaries = dictionary["categories"] as? [[String:Any]] {
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
        self.name = dictionary["name"] as? String ?? ""
        if let dictionaries = dictionary["missing"] as? [[String:Any]] {
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
        self.firstname = dictionary["firstname"] as? String ?? ""
        self.lastname = dictionary["lastname"] as? String ?? ""
        self.dni = dictionary["dni"] as? String ?? ""
        self.age = dictionary["edad"] as? Int ?? 0
        self.description = dictionary["descripcion"] as? String ?? ""
        self.imageUrl = dictionary["imagen"] as? String ?? ""
        self.longitude = dictionary["longitude"] as? Double ?? 0
        self.latitude = dictionary["latitude"] as? Double ?? 0
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
