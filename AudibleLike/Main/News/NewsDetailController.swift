//
//  NewsDetailController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/4/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class NewsDetailController: UIViewController {
    // MARK: - Object Variables
    var news: News! {
        didSet {
            titleLabel.text = news.title
            newsTextView.text = news.content
            photoImageView.loadImage(with: news.imageUrl)
        }
    }

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let newsTextView: UITextView = {
        let tv = UITextView()
        tv.isUserInteractionEnabled = false
        tv.font = .systemFont(ofSize: 14)
        return tv
    }()
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(newsTextView)
        view.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { (make) in
            make.right.left.equalTo(view)
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.height.equalTo(view.frame.height*(2/7))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(photoImageView.snp.bottom).offset(8)
            make.right.left.equalTo(view).inset(UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
        }
        newsTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.right.left.equalTo(titleLabel)
            make.bottom.equalTo(view).offset(8)
        }
    }
}
