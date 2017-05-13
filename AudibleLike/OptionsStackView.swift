//
//  OptionsStackView.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/10/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class OptionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitleColor(UIColor(white: 0.1, alpha: 0.6), for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 15)
        backgroundColor = .white
        
        
        layer.cornerRadius = 16
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OptionsStackView: UIStackView {
    
    // MARK: - HomeControll Delegate
    var homeDelegate: HomeDelegate?
    
    var buttonArray: [UIButton] {
        return [searchButton, addButton, showMapButton, showNewsButton]
    }
    
    // MARK: - Interface Objects
    let searchButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Buscar Personas", for: .normal)
        button.addTarget(self, action: #selector(handleSearchView), for: .touchUpInside)
        return button
    }()
    
    let addButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Presentar Denuncia", for: .normal)
        return button
    }()
    
    let showMapButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Ver Mapa", for: .normal)
        return button
    }()
    
    let showNewsButton: OptionButton = {
        let button = OptionButton()
        button.setTitle("Ver Noticias", for: .normal)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spacing = 24
        distribution = .fillEqually
        axis = .vertical        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addArrangedSubview(searchButton)
        addArrangedSubview(addButton)
        addArrangedSubview(showMapButton)
        addArrangedSubview(showNewsButton)
    }
}


// MARK: - Handle Actions

extension OptionsStackView {
    
    func handleSearchView() {
        let vc = SearchTableViewController()
        homeDelegate?.handleDismissToPushVC { _ in
            self.homeDelegate?.pushTableView(customController: vc)
        }        
    }
}
