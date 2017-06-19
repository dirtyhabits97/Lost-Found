//
//  ReportController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 6/15/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class ReportController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupNavBar() {
        let image = #imageLiteral(resourceName: "logo").resize(width: view.frame.width)
        view.backgroundColor = UIColor(patternImage: image!).withAlphaComponent(0.2)
        navigationItem.title = "Denuncia"
    }
}
