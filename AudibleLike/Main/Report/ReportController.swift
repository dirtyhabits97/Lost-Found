//
//  ReportController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 6/15/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class ReportController: UIViewController {
    
    // MARK: - Object Variables
    
    var lostPeople: [Lost]?
    var originalHeight:CGFloat {
        return view.frame.height * (4 / 7 )
    }
    
    // MARK: - Interface Objects
    
    lazy var dniTextField: PaddedTextField = {
        let tf = PaddedTextField()
        tf.delegate = self
        tf.placeholder = "DNI"
        tf.font = .systemFont(ofSize: 18)
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.returnKeyType = .done
        return tf
    }()
    lazy var nameTextField: PaddedTextField = {
        let tf = PaddedTextField()
        tf.placeholder = "Nombre Desaparecido"
        tf.delegate = self
        tf.font = .systemFont(ofSize: 18)
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.returnKeyType = .done
        return tf
    }()
    lazy var reportTextView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.autocorrectionType = .no
        tv.spellCheckingType = .no
        tv.text = "Denuncia"
        tv.textColor = UIColor(white: 0.7, alpha: 1)
        tv.font = .systemFont(ofSize: 18)
        tv.backgroundColor = .clear
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        return tv
    }()
    lazy var sendReportButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enviar Reporte", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = orangeColor.withAlphaComponent(0.6)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSendReport), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeKeyboardNotification()
        setupTapGesture()
        setupNavBar()
        setupViews()
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupNavBar() {
        let image = #imageLiteral(resourceName: "logo").resize(width: view.frame.width)
        view.backgroundColor = UIColor(patternImage: image!).withAlphaComponent(0.2)
        navigationItem.title = "Denuncia"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(handleCancelReport))
    }
    fileprivate func setupViews() {
        reportTextView.selectedTextRange = reportTextView.textRange(from: reportTextView.beginningOfDocument, to: reportTextView.beginningOfDocument)
        
        let stackView = UIStackView(arrangedSubviews: [dniTextField, nameTextField])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        view.addSubview(stackView)
        view.addSubview(reportTextView)
        view.addSubview(sendReportButton)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
            make.height.equalTo(80)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(8)
        }
        reportTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(stackView)
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.height.equalTo(originalHeight)
        }
        sendReportButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(stackView)
            make.height.equalTo(50)
            make.top.equalTo(reportTextView.snp.bottom).offset(8)
        }
    }
    fileprivate func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Handle Methods
    
    func handleTap() {
        if nameTextField.frame.height != originalHeight {
            nameTextField.resignFirstResponder()
            dniTextField.resignFirstResponder()
            reportTextView.resignFirstResponder()
        }
    }
    func handleSendReport() {
        if !(reportTextView.text.isEmpty) && !(reportTextView.text == "Denuncia") && (reportTextView.text.characters.count < 601){
            guard let currentUser = UserDefaults.standard.unarchiveUser().username else { return }
            Service.sharedInstance.sendReport(from: currentUser, for: dniTextField.text ?? "", name: nameTextField.text ?? "", reportTextView.text, completion: { (result) in
                // TO DO
            })
        } else {
            let alert = UIAlertController(title: "Aviso", message: "La denuncia no puede estar vacía", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    func handleCancelReport() {
        let alert = UIAlertController(title: "¿Está seguro que desea no continuar la denuncia?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: { (_) in
            self.handleReportDismiss()
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func handleReportDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - TextViewDelegate Methods

extension ReportController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let placeholderColor = UIColor(white: 0.7, alpha: 1)
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = "Denuncia"
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            sendReportButton.backgroundColor = orangeColor.withAlphaComponent(0.6)
            return false
        } else if (textView.textColor == placeholderColor) && !(text.isEmpty) {
            textView.text = ""
            textView.textColor = .black
            sendReportButton.backgroundColor = orangeColor.withAlphaComponent(0.6)
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
    func textViewDidChange(_ textView: UITextView) {
        if !(reportTextView.text.isEmpty) && !(reportTextView.text == "Denuncia") && (reportTextView.text.characters.count < 601){
            sendReportButton.backgroundColor = orangeColor.withAlphaComponent(1)
        } else {
            sendReportButton.backgroundColor = orangeColor.withAlphaComponent(0.6)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        reportTextView.resignFirstResponder()
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        reportTextView.resignFirstResponder()
        return true
    }
}


// MARK: - TextFieldDelegate Methods

extension ReportController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
        dniTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        dniTextField.resignFirstResponder()
        return true
    }
}

// MARK: - Observer Methods

extension ReportController {
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardWillHide, object: nil)
    }
    func showKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
            self.reportTextView.snp.updateConstraints({ (make) in
                make.height.equalTo(150)
            })
        })
    }
    func hideKeyboard() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.reportTextView.snp.updateConstraints({ (make) in
                make.height.equalTo(self.originalHeight)
            })
        })
    }
}
