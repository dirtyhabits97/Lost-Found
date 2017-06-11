//
//  DetailViewController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/29/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    // MARK: - Object Variables
    
    var lostPerson: Lost! {
        didSet {
            let attributedTextForName = NSMutableAttributedString(string: "Nombre: ", attributes: [NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
            attributedTextForName.append(NSAttributedString(string: lostPerson.lastname + ", " + lostPerson.firstname))
            nameLabel.attributedText = attributedTextForName
            let attributedTextForDNI = NSMutableAttributedString(string: "DNI: ", attributes: [NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
            attributedTextForDNI.append(NSAttributedString(string: lostPerson.dni))
            dniLabel.attributedText = attributedTextForDNI
            let attributedTextForAge = NSMutableAttributedString(string: "Edad: ", attributes: [NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)])
            attributedTextForAge.append(NSAttributedString(string: "\(lostPerson.age)"))
            ageLabel.attributedText = attributedTextForAge
            let attributedTextForDetail = NSMutableAttributedString(string: "Descripción: \n", attributes: [NSForegroundColorAttributeName: UIColor(white: 0.8, alpha: 1), NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
            attributedTextForDetail.append(NSAttributedString(string: lostPerson.description))
            detailLabel.attributedText = attributedTextForDetail
            
            photoImageView.image = lostPerson.image
        }
    }
    
    
    // MARK: - Interface Objects
        
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = orangeColor
        return iv
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let dniLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let ageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let detailLabel: UITextView = {
        let tv = UITextView()
        tv.isSelectable = false
        tv.isEditable = false
        return tv
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.nameLabel, self.dniLabel, self.ageLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(handleClueView))
        navigationItem.title = "Detalle"
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(photoImageView)
        view.addSubview(detailLabel)
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom).offset(8)
            make.centerX.equalTo(view)
            make.height.equalTo(80)
        }
        photoImageView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(view)
            make.height.equalTo(view.frame.height*(4/7))
        }
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(24)
            make.right.equalTo(view).offset(-24)
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.bottom.equalTo(view)
        }
    }
    
    func handleClueView() {
        let clueViewController = ClueViewController()
        clueViewController.lostPerson = lostPerson
        navigationController?.pushViewController(clueViewController, animated: true)
    }
}
