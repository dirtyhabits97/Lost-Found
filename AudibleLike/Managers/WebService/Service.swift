//
//  Service.swift
//  AudibleLike
//
//  Created by GERH on 4/29/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

struct Service {
    
    let tron = TRON(baseURL: "https://lostnf.herokuapp.com")
    
    static let sharedInstance = Service()
    
    func fetchRegisterResult(_ name: String, _ username:String, _ password:String, completion: @escaping (Bool)->()) {
        let req:APIRequest<Credential, JSONError> = tron.request("/register")
        req.parameters = ["name" : name, "username" : username, "password" : password]
        req.perform(withSuccess: { (response) in
            print("Succesfully registered user")
            completion(response.result)
        }) { (err) in
            print("Failed to register user...", err)
        }
    }
    
    func fetchLogged(_ username:String, _ password:String, completion: @escaping (User)->()) {
        let req:APIRequest<User, JSONError> = tron.request("/login")
        req.parameters = ["username" : username, "password" : password]
        req.perform(withSuccess: { (user) in
            print("User got fetched")
            completion(user)
        }) { (err) in
            print("Failed to fetch user from loging...", err)
        }
    }
    
    
    func fetchCategories(completion: @escaping ([LostCategory])->()) {
        let req:APIRequest<Categories, JSONError> = tron.request("/list")
        req.perform(withSuccess: { (categories) in
            guard let categoryArray = categories.lostCategories else {
                print("It was empty")
                return
            }
            print("Categories got fetched", categoryArray)
            completion(categoryArray)
        }) { (err) in
            print("Failed to fetch categories...", err)
        }
    }
    
    func sendClueFor(_ idLostPerson: String, from idUser: String, _ subject: String, _ detail: String, completion: @escaping (Bool)->()) {
        let req:APIRequest<Credential, JSONError> = tron.request("/clue")
        req.parameters = ["idUsuario":idUser, "idPerdido":idLostPerson, "asunto":subject, "descripcion":detail]
        req.perform(withSuccess: { (response) in
            print("Clue was sent succesfuly")
            completion(response.result)
        }) { (err) in
            print("Failed to send clue...", err)
        }
        
    }
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("JSON ERROR")
        }
    }
}
