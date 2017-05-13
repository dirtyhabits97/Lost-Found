//
//  MainNavigationController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if isLogged() {
            let flowLayout = UICollectionViewFlowLayout()
            let homeController = HomeController(collectionViewLayout: flowLayout)
            homeController.user = UserDefaults.standard.unarchiveUser()
            viewControllers = [homeController]
        }else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    
    // MARK: - UserDefaults Methods
    
    fileprivate func isLogged() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true) {
            //something goes here
        }
    }
    
}
