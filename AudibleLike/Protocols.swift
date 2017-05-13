//
//  LoginController+delegate.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/8/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

protocol LoginControllerDelegate: class {
    func finishLoggingIn(_ username:String, _ password:String)
    func finishRegister(_ name: String, _ username:String, _ password:String)
    func loadAlert(_ alert: UIAlertController)
}

protocol HomeDelegate: class {
    func pushOptionViews<T: UIViewController>(customController: T)
    func pushTableView<T: UITableViewController>(customController: T)
    func handleDismissToPushVC(completion: @escaping () -> ())
}
