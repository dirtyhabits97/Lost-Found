//
//  ProfileDetailCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/11/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class ProfileDetailCell: BaseTableViewCell {    
    
    let settingInfoLabel: UILabel  = {
        let label = UILabel()
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(settingInfoLabel)
        addSubview(infoLabel)
        
        settingInfoLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.centerY.equalTo(self)
        }
        
        infoLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(self)
        }
    }
    
}
