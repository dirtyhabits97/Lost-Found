//
//  LostPersonCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/9/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

protocol LostPersonCellDelegate: class {
    func showDetailFor(lostPerson: Lost)
}

class LostPersonCell: UICollectionViewCell {
    
    // MARK: - Object Variables
    
    var lostPerson: Lost! {
        didSet {
            nameLabel.text = lostPerson.lastname + ", " + lostPerson.firstname
        }
    }
    
    fileprivate var width: CGFloat {
        return frame.width - 14
    }
    
    // MARK: - Interface Objects
    
    lazy var photoImage: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = orangeColor
        iv.layer.cornerRadius = self.width / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: Setup Views

extension LostPersonCell {
    func setupViews() {
        backgroundColor = .clear
        addSubview(photoImage)
        addSubview(nameLabel)
        
        photoImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(width)
            make.centerX.top.equalTo(self)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(photoImage).offset(4)
            make.top.equalTo(photoImage.snp.bottom).offset(4)
        }
        
    }
}
