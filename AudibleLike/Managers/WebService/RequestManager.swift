//
//  RequestManager.swift
//  AudibleLike
//
//  Created by GERH on 6/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

extension Service {
    class RequestManager {
        let params: [String:Any]
        let resource: Resource
        init(params: [String:Any], resource: Resource) {
            self.params = params
            self.resource = resource
        }
        
        func doRequest() -> (URLRequest, URLSession)? {
            if resource.httpMethod == "GET" {
                return doGet()
            } else if resource.httpMethod == "POST" {
                return doPost()
            }
            return nil
        }
        
        fileprivate func doGet() -> (URLRequest, URLSession)? {
            let urlComp = NSURLComponents(string: Service.sharedInstance.baseUrl + resource.path)
            var items = [URLQueryItem]()
            for (key, value) in params {
                items.append(URLQueryItem(name: key, value: String(describing: value)))
            }
            let queryItems = items.filter { !$0.name.isEmpty }
            if !items.isEmpty {
                urlComp?.queryItems = queryItems
            }
            guard let url = urlComp?.url else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = resource.httpMethod
            let session = URLSession(configuration: URLSessionConfiguration.default)
            return (urlRequest, session)
        }
        
        fileprivate func doPost() -> (URLRequest, URLSession)? {
            guard let url = URL(string: Service.sharedInstance.baseUrl + resource.path) else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = resource.httpMethod
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            let session = URLSession(configuration: URLSessionConfiguration.default)
            return (urlRequest, session)
        }
    }
}
