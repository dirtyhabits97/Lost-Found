//
//  Service.swift
//  AudibleLike
//
//  Created by GERH on 4/29/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

struct Service {
    
    fileprivate let baseUrl = "https://lostnf.herokuapp.com"
    
    static let sharedInstance = Service()
    
    fileprivate enum Resource {
        case login, register, list, clue, report, test
        var path: String {
            switch self{
            case .login: return "/login"
            case .register: return "/register"
            case .list: return "/list"
            case .clue: return "/clue"
            case .report: return "/report"
            case .test: return "/test"
            }
        }
        var httpMethod: String {
            switch self {
            case .list, .login, .test: return "GET"
            case .register, .clue, .report: return "POST"
            }
        }
    }
    fileprivate class RequestManager {
        let params: [String:Any]
        let resource: Resource
        init(params: [String:Any], resource: Resource) {
            self.params = params
            self.resource = resource
        }
        func doRequest() -> (URLRequest, URLSession)? {
            let urlComp = NSURLComponents(string: Service.sharedInstance.baseUrl + resource.path)
            if resource.httpMethod == "GET" {
                var items = [URLQueryItem]()
                for (key, value) in params {
                    items.append(URLQueryItem(name: key, value: String(describing: value)))
                }
                let queryItems = items.filter { !$0.name.isEmpty }
                if !items.isEmpty {
                    urlComp?.queryItems = queryItems
                }
            }
            guard let url = urlComp?.url else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = resource.httpMethod
            if resource.httpMethod == "POST" {
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            }
            let session = URLSession(configuration: URLSessionConfiguration.default)
            return(urlRequest, session)
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
        let params = ["idUsuario":idUser, "idPerdido":idLostPerson, "asunto":subject, "descripcion":detail]
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
        let params = ["idUsuario":idUser, "idLostPerson":idLostPerson, "nombre":name, "report":report]
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
