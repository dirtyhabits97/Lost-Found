//
//  HomeController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeDelegate, LostPersonCellDelegate{
    
    // MARK: - Object Variables
    
    var user: User!
    var categories: [LostCategory]? {
        didSet {
            guard let categories = categories, categories.count > 0 else { everyLostPeople = nil; return }
            var aux: [Lost] = []
            for category in categories {
                if let lostArray = category.lostArray {
                    aux += lostArray
                }
            }
            everyLostPeople = aux
        }
    }
    
    var everyLostPeople: [Lost]?
    
    fileprivate let cellId = "cellId"
    fileprivate let y:CGFloat = 104
    fileprivate let xOffset: CGFloat = 14
    
    // MARK: - Interface Objects
    
    let whiteView = UIView()
    
    lazy var moreOptionsView: OptionsStackView = {
        let sv = OptionsStackView()
        sv.homeDelegate = self
        return sv
    }()
        
    lazy var profileButton: UIButton = {
       let button = UIButton(type: .system)
       button.setImage(#imageLiteral(resourceName: "userIcon"), for: .normal)
       button.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
       button.tintColor = orangeColor
       button.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
       return button
    }()
    
    var moreOptionsButton: UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showMoreOptions))
        button.tintColor = orangeColor
        return button
    }
    
    
    // MARK: - View Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()        
        navigationController?.navigationBar.tintColor = orangeColor
        collectionView?.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.rightBarButtonItem = moreOptionsButton
        navigationItem.title = user.username
        collectionView?.register(HomeControllerCell.self, forCellWithReuseIdentifier: cellId)
        
        Service.sharedInstance.fetchCategories { (categories) in
            self.categories = categories
            self.collectionView?.reloadData()
        }
    }
}


// MARK: - Delegate Methods

extension HomeController {
    func pushOptionViews<T>(customController: T) where T : UIViewController {
        handleDismiss()
        navigationController?.pushViewController(customController, animated: true)
    }
    func handleSearchTableViewController() {
        handleDismiss()
        let searchTableViewController = SearchTableViewController()
        searchTableViewController.everyLostPeople = everyLostPeople ?? []
        navigationController?.pushViewController(searchTableViewController, animated: true)
    }    
    func showDetailFor(lostPerson: Lost) {
        let detailViewController = DetailViewController()
        detailViewController.lostPerson = lostPerson
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func handleReportView() {
        handleDismiss()
        let reportController = ReportController()
        navigationController?.pushViewController(reportController, animated: true)
    }
    func handleMapView() {
        handleDismiss()
        let mapController = MapController()
        mapController.everyLostPeople = everyLostPeople
        present(mapController, animated: true)
    }
    func handleNewsController() {
        
    }
}


// MARK: - Handle Actions

extension HomeController {
    
    
    
    func showProfile() {
        let profileController = ProfileController()
        profileController.user = user
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    func showMoreOptions() {
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            whiteView.backgroundColor = UIColor(white: 1, alpha: 0.7)
            
            whiteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(whiteView)
            window.addSubview(moreOptionsView)
            moreOptionsView.frame = CGRect(x: window.frame.width, y: y, width: window.frame.width/2, height: 200)
            
            whiteView.frame = window.frame
            whiteView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.whiteView.alpha = 1
                self.moreOptionsView.frame = CGRect(x: (window.frame.width/2) - self.xOffset, y: self.y, width: window.frame.width/2, height: 200)
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.1) { 
            self.whiteView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.moreOptionsView.frame = CGRect(x: window.frame.width, y: self.y, width: self.moreOptionsView.frame.width, height: self.moreOptionsView.frame.height)
            }
        }
    }
//    func handleDismissToPushVC(completion: @escaping () -> ()) {
//        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: { 
//            
//            self.whiteView.alpha = 0
//            if let window = UIApplication.shared.keyWindow {
//                self.moreOptionsView.frame = CGRect(x: window.frame.width, y: self.y, width: self.moreOptionsView.frame.width, height: self.moreOptionsView.frame.height)
//            }
//            
//        }) { _ in
//            completion()
//        }
//    }
}


// MARK: - CollectionView Methods

extension HomeController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = categories else { return 0 }
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeControllerCell
        let category = categories?[indexPath.item]
        cell.lostCategory = category
        cell.lostPersonCellDelegate = self
        return cell
    }
}


// MARK: - FlowLayout Methods

extension HomeController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
