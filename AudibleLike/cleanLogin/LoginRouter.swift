//
//  LoginRouter.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/7/17.
//  Copyright (c) 2017 Gonzalo Reyes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//  Template modified by Gabriel Lanata (http://StartApps.pe)
//

import UIKit

class LoginRouter: LoginControllerDelegate {
    
    weak var viewController: LoginController!
    
    // MARK: - Navigation
    
    func navigateToHome(user: User) {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        guard let homeNavController = rootViewController as? HomeNavigationController else {
            print("Not a Home Navigation Controller")
            return
        }
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        homeController.user = user
        UserDefaults.standard.archiveUser(user)
        homeNavController.viewControllers = [homeController]
        UserDefaults.standard.setIsLoggedIn(value: true)
        viewController.dismiss(animated: true)
    }
    
    // MARK: - LoginControllerDelegate Methods
    
    func finishLoggingIn(_ username: String, _ password: String) {
        let params = ["username":username, "password":password]
        viewController.checkLogin(params: params)
    }
    
    func finishRegister(_ name: String, _ username:String, _ password:String) {
        let params = ["name":name, "username":username, "password":password]
        viewController.checkRegister(params: params)
    }
    
    func loadAlert(_ alert: UIAlertController) {
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
