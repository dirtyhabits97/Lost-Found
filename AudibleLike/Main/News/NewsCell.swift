//
//  NewsCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/4/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    
    // MARK: - Object Variables
    var news: News! {
        didSet {
            titleLabel.text = news.title
            newsImageView.loadImage(with: news.imageUrl)
            teaserTextView.text = news.teaser
        }
    }
    
    var width: CGFloat {
        return (self.frame.width - 14 - 14) * (2/5)
    }
    
    // MARK: - Interface Objects
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    let newsImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    let teaserTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 14)
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    // MARK: - View LifeCycle
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(newsImageView)
        addSubview(teaserTextView)
        titleLabel.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self).inset(UIEdgeInsets(top: 8, left: 14, bottom: 0, right: 14))
        }
        newsImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalTo(titleLabel)
            make.width.equalTo(width)
            make.bottom.lessThanOrEqualTo(teaserTextView)
        }
        teaserTextView.snp.makeConstraints { (make) in
            make.top.equalTo(newsImageView)
            make.left.equalTo(newsImageView.snp.right).offset(4)
            make.right.equalTo(titleLabel)
            make.bottom.equalTo(self).offset(-8)
        }
    }
}
