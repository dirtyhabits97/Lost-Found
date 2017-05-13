//
//  UserDefaults+helpers.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultsKey:String {
        case isLoggedIn
        case isUserArchived
    }
    
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKey.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKey.isLoggedIn.rawValue)
    }
    
    //
    
    func archiveUser(_ value: User) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        set(encodedData, forKey: UserDefaultsKey.isUserArchived.rawValue)
        synchronize()
    }
    
    func unarchiveUser() -> User{
        let decoded = object(forKey: UserDefaultsKey.isUserArchived.rawValue) as! Data
        let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
        return decodedUser
    }
    
    func removeUser() {
        removeObject(forKey: UserDefaultsKey.isUserArchived.rawValue)
    }
    
}
