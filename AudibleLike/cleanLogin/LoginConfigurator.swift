//
//  LoginConfigurator.swift
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

// MARK: - Connect View, Interactor, and Presenter

class LoginConfigurator {
    
    // MARK: - Configuration
    
    static func configure(viewController: LoginController) {
        let router = LoginRouter()
        router.viewController = viewController
        
        let presenter = LoginPresenter()
        presenter.viewController = viewController
        
        let interactor = LoginInteractor()
        interactor.presenter = presenter
        
        viewController.interactor = interactor
        viewController.router = router
    }
}
