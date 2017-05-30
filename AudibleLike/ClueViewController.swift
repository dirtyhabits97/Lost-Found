//
//  ClueViewController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/29/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class ClueViewController: UIViewController, UITextFieldDelegate {
    
    var lostPerson: Lost! {
        didSet {
            
        }
    }
    
    let dividerLineView: UIView = {
        let view = UIView()
        //choose any color tbh
        view.backgroundColor = UIColor(white: 0.75, alpha: 1)
        return view
    }()
    
    
    let subjectTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Asunto"
        textfield.font = .systemFont(ofSize: 18)
        return textfield
    }()
    
    let clueTextView: UITextView = {
        let tv = UITextView()
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.text = "Prueba"
        tv.font = .systemFont(ofSize: 14)
        return tv
    }()
    
    let sendButton: UIBarButtonItem = {
        let sendButton = UIBarButtonItem(title: "Enviar", style: .plain, target: self, action: #selector(handleSendClue))
        return sendButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(handleDismissClue))
        
        navigationItem.rightBarButtonItem = sendButton
        navigationItem.title = "Nueva Pista"
        setupViews()
    }
    
    func handleDismissClue() {
        let alert = UIAlertController(title: "¿Está seguro que desea eliminar esta pista?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { (_) in
            self.handleDismiss()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func handleSendClue() {
        let alert = UIAlertController(title: "Pista Enviada", message: nil, preferredStyle: .alert)
        present(alert, animated: true) { 
            self.dismiss(animated: true, completion: { 
                self.navigationController?.popViewController(animated: true)
            })
        }        
    }
    
    
    // MARK: - Setup Views
    
    func setupViews() {
        view.addSubview(subjectTextField)
        view.addSubview(clueTextView)
        view.addSubview(dividerLineView)
        
        subjectTextField.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(14)
            make.right.equalTo(view).offset(-14)
            make.top.equalTo(view).offset(8)
            make.height.equalTo(40)
        }
        subjectTextField.becomeFirstResponder()
        
        dividerLineView.snp.makeConstraints { (make) in
            make.top.equalTo(subjectTextField.snp.bottom)
            make.right.equalTo(view)
            make.left.equalTo(subjectTextField)
            make.height.equalTo(0.4)
        }

        clueTextView.snp.makeConstraints { (make) in
            make.top.equalTo(dividerLineView.snp.bottom)
            make.left.right.equalTo(subjectTextField)
            make.bottom.equalTo(view)
        }
    }
}
