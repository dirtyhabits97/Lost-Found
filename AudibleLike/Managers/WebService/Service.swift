//
//  Service.swift
//  AudibleLike
//
//  Created by GERH on 4/29/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

struct Service {
    
    var baseUrl: String {
        return "https://lostnf.herokuapp.com"
    }
    
    static let sharedInstance = Service()
    
    enum Resource {
        case login, register, list, clue, report, test
        var path: String {
            switch self{
            case .login: return "/login/"
            case .register: return "/register/"
            case .list: return "/list"
            case .clue: return "/clue/"
            case .report: return "/report/"
            case .test: return "/test"
            }
        }
        var httpMethod: String {
            switch self {
            case .list, .test: return "GET"
            case .register,.login ,.clue, .report: return "POST"
            }
        }
    }
       
    func fetchRegisterResult(_ name: String, _ username:String, _ password:String, completion: @escaping (Bool)->()) {
        let params = ["name":name, "username":username, "password":password]
        let requestManager = RequestManager(params: params, resource: .register)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to receive result from register: ", err)
                return
            }
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let credential = Credential(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(credential.result)
            }
        }.resume()
    }
    
    func fetchLogged(_ username:String, _ password:String, completion: @escaping (User)->()) {
        let params = ["username":username, "password":password]
        let requestManager = RequestManager(params: params, resource: .login)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to do login: ", err)
                return
            }
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let user = User(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(user)
//                gonzalorehu
                
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping ([LostCategory])->()) {
        let params = [String:String]()
        let requestManager = RequestManager(params: params, resource: .list)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to fetch categories: ", err)
                return
            }
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let categories = Categories(dictionary: dictionary)
            guard let lostCategories = categories.lostCategories else { return }
            DispatchQueue.main.async {
                completion(lostCategories)
            }
        }.resume()
    }
    
    func sendClue(for idLostPerson: String, from idUser: String, _ subject: String, _ detail: String, completion: @escaping (Bool)->()) {
        let params = ["idUser":idUser, "idLostPerson":idLostPerson, "subject":subject, "description":detail]
        let requestManager = RequestManager(params: params, resource: .clue)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to receive result from sending clue: ", err)
                return
            }
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let credential = Credential(dictionary: dictionary)
            DispatchQueue.main.async {
                print(credential.result)
                completion(credential.result)
            }
        }.resume()
    }
    
    func sendReport(from idUser: String, for idLostPerson: String, name: String, _ report: String, completion: @escaping (Bool) -> ()) {
        let params = ["idUser":idUser, "idLostPerson":idLostPerson, "name":name, "report":report]
        let requestManager = RequestManager(params: params, resource: .report)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to receive result from sending report: ", err)
                return
            }
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let credential = Credential(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(credential.result)
            }
        }.resume()
    }
}
