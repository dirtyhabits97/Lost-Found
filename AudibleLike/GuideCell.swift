//
//  GuideCell.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class GuideCell:UICollectionViewCell {
    
    // MARK: - Object Variables
    
    var page: Page? {
        didSet {
            guard let page = page else {return}
            imageView.image = UIImage(named: page.imageName)
            
            //color for the text so it looks dope af
            let color = UIColor(white: 0.2, alpha: 1)
            
            //attributed string
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color])
            
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium), NSForegroundColorAttributeName: color]))
            
            //paragraph style, need to center the textview's text
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            //this range thing is hard af
            //lenght has to be the same as the characters count
            let length = attributedText.string.characters.count
            attributedText.addAttributes([NSParagraphStyleAttributeName:paragraphStyle], range: NSRange(location: 0, length: length))

            textView.attributedText = attributedText            
        }
    }
    
    
    // MARK: - Interface Objects
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        //top padding so text looks dope
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.isSelectable = false
        tv.isEditable = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //divider line in case both backgrounds colors are the same
    let dividerLineView: UIView = {
        let view = UIView()
        //choose any color tbh
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: - View Lifecycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Setup Views

extension GuideCell {
    func setupViews() {
        addSubview(imageView)
        addSubview(textView)
        addSubview(dividerLineView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        //16px each side so text looks cleaner and dope
        //gotta set the cell's background to white tho
        textView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        //set the textview to a 0.3 of the view's height
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        dividerLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
