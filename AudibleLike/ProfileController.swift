//
//  ProfileController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/28/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit
import AlamofireImage

class ProfileController: UITableViewController{
    
    // MARK: - Object Variables
    
    fileprivate let cellId = "cellId"
    fileprivate let footerId = "footerId"
    
    var user: User!
    
    enum profileItem: Int {
        case dni = 0, name, username, age, email
        
        var title: String{
            switch self {
            case .dni: return "DNI: "
            case .name: return "Nombre: "
            case .username: return "Usuario: "
            case .age: return "Edad: "
            case .email: return "Email: "
            }
        }
        
        func getInfo(user: User) -> String{
            switch self {
            case .dni: return ""
            case .name: return user.name
            case .username: return user.username
            case .age: return ""
            case .email: return user.username + "@gmail.com"
            }
        }
        
        static var count: Int { return email.rawValue + 1}
    }
    
    
    // MARK: - Interface Objects
    
    lazy var logOutButton: UIBarButtonItem  = {
        let button = UIBarButtonItem(title: "Cerrar Sesión", style: .plain, target: self, action: #selector(handleLogOut))
        return button
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.rightBarButtonItem = logOutButton
        navigationController?.navigationBar.tintColor = orangeColor
        view.backgroundColor = UIColor(red: 0.89, green: 0.90, blue: 0.92, alpha: 1)
    }
    
    func setupViews() {
        tableView.register(ProfileDetailCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: footerId)
    }
}


// MARK: - TableView Methods

extension ProfileController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return profileItem.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        switch section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileDetailCell
            let item = profileItem.init(rawValue: indexPath.row)
            cell.settingInfoLabel.text = item?.title
            cell.infoLabel.text = item?.getInfo(user: user)
//          cell.textLabel?.text = profileItem.init(rawValue: indexPath.row)?.title
//          cell.preservesSuperviewLayoutMargins = false
//          cell.separatorInset = UIEdgeInsets.zero
//          cell.layoutMargins = UIEdgeInsets.zero
            return cell
        
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ProfileDetailCell
            let item = profileItem.init(rawValue: indexPath.row)
            cell.settingInfoLabel.text = item?.title
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 80 : 0
    }
}


// MARK: - Handle Actions

extension ProfileController {
    
    func handleLogOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.removeUser()
        let loginController = LoginController()
        navigationController?.present(loginController, animated: true, completion: nil)
    }
    
    func handleReturn() {
        dismiss(animated: true, completion: nil)
    }
    
}


