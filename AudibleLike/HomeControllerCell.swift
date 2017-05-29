//
//  HomeControllerCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/9/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class HomeControllerCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Object Variables
    
    fileprivate let cellId = "cellId"
    
    var lostCategory: LostCategory! {
        didSet {
            categoryLabel.text = lostCategory.name
        }
    }
    
    var lostArray: [Lost]{
        if let lost = lostCategory.lostArray {
            return lost
        }
        return []
    }
    
    var auxHeight: CGFloat {
        return frame.height
    }
    
    var auxHeightMinus: CGFloat {
        return 28 + 6 + 6 + 2
    }
    
    weak var lostPersonCellDelegate: LostPersonCellDelegate?
    
    // MARK: - Interface Objects
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    lazy var lostCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        flowLayout.itemSize = CGSize(width: 120, height: self.auxHeight - self.auxHeightMinus)
        flowLayout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        return cv
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


// MARK: - Setup Views

extension HomeControllerCell {
    func setupViews() {
        
        lostCollectionView.register(LostPersonCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(categoryLabel)
        addSubview(lostCollectionView)
        addSubview(dividerLine)
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(6)
            make.left.equalTo(self).offset(14)
            make.height.equalTo(28)
        }
        
        lostCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryLabel.snp.bottom).offset(6)
            make.right.left.equalTo(self)
            make.bottom.equalTo(dividerLine.snp.top)
        }
        
        dividerLine.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.height.equalTo(0.5)
            make.right.equalTo(self)
            make.left.equalTo(self).offset(14)
        }
    }
}


// MARK: - CollectionView Methods

extension HomeControllerCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lostArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LostPersonCell
        let lostPerson = lostArray[indexPath.item]
        cell.lostPerson = lostPerson
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! LostPersonCell
        lostPersonCellDelegate?.showDetailFor(lostPerson: cell.lostPerson)
    }
}
