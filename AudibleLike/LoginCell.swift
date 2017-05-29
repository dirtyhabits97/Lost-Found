//
//  LoginCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit
import MyExtensions

class LoginCell: UICollectionViewCell, UITextFieldDelegate {
    
    // MARK: - Delegate reference
    
    weak var delegate: LoginControllerDelegate?
    
    
    // MARK: - Interface Objects
    
    var nameTextFieldTopConstraint: Constraint?
    
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let iv = UIImageView(image: image)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var emailTextField: UIPaddedTextField = {
        let textField = UIPaddedTextField()
        textField.delegate = self
        textField.placeholder = "Enter email"
        textField.keyboardType = .emailAddress
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordTextField: UIPaddedTextField = {
        let textField = UIPaddedTextField()
        textField.placeholder = "Enter password"
        textField.delegate = self
        textField.isSecureTextEntry = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var nameTextField: UIPaddedTextField = {
        let textField = UIPaddedTextField()
        textField.isHidden = true
        textField.delegate = self
        textField.placeholder = "Enter your name"
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = orangeColor
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Log in", "Register"])
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.tintColor = orangeColor
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Setup Views

extension LoginCell {
    func setupViews() {
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(nameTextField)
        addSubview(loginButton)
        
        setupLoginRegisterSegmentedControl()
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.centerY).offset(-260)
            make.width.height.equalTo(160)
            make.centerX.equalTo(snp.centerX)
        }
        
        //text fields with 50px height look good
        emailTextField.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.right.equalTo(snp.right).offset(-32)
            make.left.equalTo(snp.left).offset(32)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.left.right.height.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.left.right.height.equalTo(emailTextField)
        }
        
        nameTextField.snp.makeConstraints { (make) in
            nameTextFieldTopConstraint = make.top.equalTo(loginRegisterSegmentedControl.snp.bottom).constraint
            make.height.equalTo(0)
            make.left.right.equalTo(emailTextField)
            
        }
    }
    
    func setupLoginRegisterSegmentedControl() {
        addSubview(loginRegisterSegmentedControl)
        loginRegisterSegmentedControl.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom)
            make.left.right.equalTo(emailTextField)
            make.height.equalTo(30)
        }
    }
}


// MARK: - Handle Actions

extension LoginCell {
    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginButton.setTitle(title, for: .normal)
        
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        
        let isLoginTab = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        remakeNameTextFieldConstraints(isLoginTab)
        nameTextField.isHidden = isLoginTab
    }
    
    func remakeNameTextFieldConstraints(_ isLoginTab: Bool) {
        if isLoginTab {
            nameTextFieldTopConstraint?.update(offset: 0)
            nameTextField.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        }else {
            nameTextFieldTopConstraint?.update(offset: 8)
            nameTextField.snp.updateConstraints({ (make) in
                make.height.equalTo(50)
            })
        }
    }
    
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleRegister()
        }
    }
    
    func handleRegister() {
        if let username = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text{
            guard !name.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Name can't be left blank", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                delegate?.loadAlert(alert)
                return
            }
            guard !username.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Username can't be left blank", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                delegate?.loadAlert(alert)
                return
            }
            guard !password.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Password can't be left blank", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                delegate?.loadAlert(alert)
                return
            }
            delegate?.finishRegister(name, username, password)
        }
    }
    
    func handleLogin() {
        if let username = emailTextField.text, let password = passwordTextField.text {
            guard !username.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Please enter a valid User", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                delegate?.loadAlert(alert)
                return
            }
            guard !password.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Please enter a password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                delegate?.loadAlert(alert)
                return
            }
            delegate?.finishLoggingIn(username, password)
        }
    }
}


// MARK: - TextFieldDelegate Methods

extension LoginCell {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        return true
    }
}


