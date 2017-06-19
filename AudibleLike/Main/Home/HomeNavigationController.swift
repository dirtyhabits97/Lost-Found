//
//  MainNavigationController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    // MARK: - Object Variables
    
    let rightToLeftAnimationTransition = RightToLeftAnimationTransition()
    let leftToRightAnimationTransition = LeftToRightAnimationTransition()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
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


// MARK: - UINavigationControllerDelegate Methods

extension HomeNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if toVC.isKind(of: ClueViewController.self) || toVC.isKind(of: ReportController.self){
            if operation == .push {
                return rightToLeftAnimationTransition
            } else if operation == .pop {
                return leftToRightAnimationTransition
            }
            
        }
        return nil
    }
}
