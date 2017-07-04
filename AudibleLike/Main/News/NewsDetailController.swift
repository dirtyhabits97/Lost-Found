//
//  NewsDetailController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/4/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController {
    // MARK: - Object Variables
    var news: News! {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
