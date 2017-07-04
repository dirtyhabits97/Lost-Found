//
//  Request.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/3/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

enum State<T> {
    case success(T)
    case failure(Error)
}

enum HTTPStatusError: Error {
    case not200
}

struct Result {
    let value: Bool
    init(dictionary: [String:Any]) {
        self.value = (dictionary["result"] as? NSNumber ?? 0) == 0 ? false : true
    }
}
