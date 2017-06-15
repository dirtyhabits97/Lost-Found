//
//  ClueViewController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/29/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class ClueViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    var lostPerson: Lost!
    
    let dividerLineView: UIView = {
        let view = UIView()
        //choose any color tbh
        view.backgroundColor = UIColor(white: 0.75, alpha: 1)
        return view
    }()
    
    
    lazy var subjectTextField: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "Asunto"
        textfield.font = .systemFont(ofSize: 18)
        return textfield
    }()
    
    lazy var clueTextView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.text = "Pista"
        tv.textColor = UIColor(white: 0.7, alpha: 1)
        tv.font = .systemFont(ofSize: 18)
        return tv
    }()
    
    let sendButton: UIBarButtonItem = {
        let sendButton = UIBarButtonItem(title: "Enviar", style: .plain, target: self, action: #selector(handleSendClue))
        return sendButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clueTextView.selectedTextRange = clueTextView.textRange(from: clueTextView.beginningOfDocument, to: clueTextView.beginningOfDocument)
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
        guard let subject = subjectTextField.text, (subject.characters.count > 0) else {
            let alert = UIAlertController(title: "Aviso", message: "El campo Asunto no puede estar vacío", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        guard (subject.characters.count < 31) else {
            let alert = UIAlertController(title: "Aviso", message: "El campo Asunto no debe exceder los 30 caracteres", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        guard let detail = clueTextView.text, (detail.characters.count > 0) && (detail != "Pista") else {
            let alert = UIAlertController(title: "Aviso", message: "El campo Pista no puede estar vacío", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        guard (detail.characters.count < 401) else {
            let alert = UIAlertController(title: "Aviso", message: "El campo Pista no debe exceder los 400 caracteres", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        guard let user = UserDefaults.standard.unarchiveUser().username else { return }
        let lostPerson = self.lostPerson.dni
        
        Service.sharedInstance.sendClueFor(lostPerson, from: user, subject, detail) { (result) in
            let title = result == false ? "Se produjo un error al enviar la pista" : "Pista Enviada"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            self.present(alert, animated: true) {
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }            
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let placeholderColor = UIColor(white: 0.7, alpha: 1)
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Pista"
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        } else if (textView.textColor == placeholderColor) && !(text.isEmpty) {
            textView.text = ""
            textView.textColor = .black
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor(white: 0.7, alpha: 1) {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
