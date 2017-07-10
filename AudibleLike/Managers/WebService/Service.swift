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
    
    static let shared = Service()
    
    enum Resource {
        case login, register, list, clue, report, test, news
        var path: String {
            switch self{
            case .login: return "/login/"
            case .register: return "/register/"
            case .list: return "/list"
            case .clue: return "/clue/"
            case .report: return "/report/"
            case .test: return "/test"
            case .news: return "/news"
            }
        }
        var httpMethod: String {
            switch self {
            case .list, .test, .news: return "GET"
            case .register,.login ,.clue, .report: return "POST"
            }
        }
    }
       
    func registerUser(for params: [String: Any], completion: @escaping (State<Bool>) -> ()) {
        let requestManager = RequestManager(params: params, resource: .register)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to receive result from register: ", err)
                completion(State.failure(err))
            }
            
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode != 200 {
                print("Failed to receive a 200 OK status")
                completion(State.failure(HTTPStatusError.not200))
            }
            
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let result = Result(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(State.success(result.value))
            }
        }.resume()
    }
    
    func loginUser(for params: [String: Any], completion: @escaping (State<User>) -> ()) {
        let requestManager = RequestManager(params: params, resource: .login)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to do login: ", err)
                completion(State.failure(err))
            }
            
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode != 200 {
                print("Failed to receive a 200 OK status")
                completion(State.failure(HTTPStatusError.not200))
            }
            
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let user = User(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(State.success(user))
                
            }
        }.resume()
    }
    
    func fetchCategories(completion: @escaping (State<[LostCategory]>) -> ()) {
        let requestManager = RequestManager(params: [String:String](), resource: .list)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to fetch categories: ", err)
                completion(State.failure(err))
            }
            
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode != 200 {
                print("Failed receive a 200 OK status")
                completion(State.failure(HTTPStatusError.not200))
            }
            
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let categories = Categories(dictionary: dictionary)
            guard let lostCategories = categories.lostCategories else { return }
            DispatchQueue.main.async {
                completion(State.success(lostCategories))
            }
        }.resume()
    }
    
    func sendClue(for params: [String: Any], completion: @escaping (State<Bool>) -> ()) {
        let requestManager = RequestManager(params: params, resource: .clue)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to receive result from sending clue: ", err)
                completion(State.failure(err))
            }
            
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode != 200 {
                print("Failed to receive a 200 OK status")
                completion(State.failure(HTTPStatusError.not200))
            }
            
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let result = Result(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(State.success(result.value))
            }
        }.resume()
    }
    
    func sendReport(for params: [String: Any], completion: @escaping (State<Bool>) -> ()) {
        let requestManager = RequestManager(params: params, resource: .report)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to receive result from sending report: ", err)
                completion(State.failure(err))
            }
            
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode != 200 {
                print("Failed to receive a 200 OK status")
                completion(State.failure(HTTPStatusError.not200))
            }
            
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String:Any] else { return }
            let result = Result(dictionary: dictionary)
            DispatchQueue.main.async {
                completion(State.success(result.value))
            }
        }.resume()
    }
    
    func fetchNewsFeed(completion: @escaping (State<NewsFeed>) -> ()) {
        let requestManager = RequestManager(params: [String:String](), resource: .news)
        guard let (request, session) = requestManager.doRequest() else { return }
        session.dataTask(with: request) { (data, response, error) in
            if let err = error {
                print("Failed to fetch news feed: ", err)
                completion(State.failure(err))
            }
            
            guard let resp = response as? HTTPURLResponse else { return }
            if resp.statusCode != 200 {
                print("Failed to receive a 200 OK status")
                completion(State.failure(HTTPStatusError.not200))
            }
            
            guard let data = data else { return }
            let dataDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let dictionary = dataDictionary as? [String: Any] else { return }
            guard let newsFeed = dictionary["News"] as? [[String: Any]] else { return }
            let news = newsFeed.map { News(dictionary: $0) }
            DispatchQueue.main.async {
                completion(State.success(news))
            }
        }.resume()
    }
}
