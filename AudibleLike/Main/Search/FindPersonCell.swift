//
//  FindPersonCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/10/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class FindPersonCell: UITableViewCell {
    
    // MARK: - Object Variables
    
    var lostPerson: Lost! {
        didSet {
            nameLabel.text = lostPerson.lastname + ", " + lostPerson.firstname
            photoImageView.image = lostPerson.image
        }
    }
    
    
    // MARK: - Interface Objects
    
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // MARK: - View Lifecycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Views
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.left.equalTo(self).offset(8)
            make.centerY.equalTo(self)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(photoImageView.snp.right).offset(8)
            make.right.equalTo(self).offset(-8)
        }
    }
    
}
