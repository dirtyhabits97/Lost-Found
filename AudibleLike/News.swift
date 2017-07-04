//
//  News.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/3/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

struct News {
    let title: String
    let imageUrl: String
    let teaser: String
    let content: String
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.teaser = dictionary["teaser"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
    }
}

typealias NewsFeed = [News]
