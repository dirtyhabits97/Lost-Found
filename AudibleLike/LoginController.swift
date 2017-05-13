//
//  ViewController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 4/24/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON
import SnapKit

class LoginController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LoginControllerDelegate{
    
    // MARK: - Object Variables
    
    fileprivate let guideCellId = "guideCellId"
    fileprivate let loginCellId = "loginCellId"
    
    var user: User?
    
    let pages = Page.getPages()
    
    
    // MARK: - Interface Objects
    
    var pageControlBottomConstraint: Constraint?
    var skipButtonTopConstraint: Constraint?
    var nextButtonTopConstraint: Constraint?
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.bounces = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
        //page control helps to keep track of the current page
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        //color for the circles
        pc.pageIndicatorTintColor = .lightGray
        pc.numberOfPages = self.pages.count + 1
        pc.isUserInteractionEnabled = false
        //this color looks cool-orange
        pc.currentPageIndicatorTintColor = orangeColor
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(orangeColor, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(orangeColor, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - View Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}


// MARK: - Setup Views

extension LoginController {
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        
        registerCells()
        observeKeyboardNotification()
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        pageControl.snp.makeConstraints { (make) in
            pageControlBottomConstraint = make.bottom.equalTo(view).constraint
            make.left.right.equalTo(view)
            make.height.equalTo(40)
        }
        
        skipButton.snp.makeConstraints { (make) in
            skipButtonTopConstraint = make.top.equalTo(view).offset(16).constraint
            make.left.equalTo(view)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
        
        nextButton.snp.makeConstraints { (make) in
            nextButtonTopConstraint = make.top.equalTo(skipButton).constraint
            make.right.equalTo(view)
            make.height.width.equalTo(skipButton)
        }
    }
}


// MARK: - Handle Actions

extension LoginController {
    
    func skip() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    func nextPage() {
        //last page
        if pageControl.currentPage == pages.count {return}
        
        //second last page
        if pageControl.currentPage == pages.count - 1{
            moveControlConstraintsOffScreen()
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
}


// MARK: - Delegate Methods

extension LoginController {
    
    func finishLoggingIn(_ username: String, _ password: String) {
        Service.sharedInstance.fetchLogged(username, password) { (user) in
            if user.username.isEmpty {
                let alert = UIAlertController(title: "Error", message: "User doesn't exist", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let rootViewController = UIApplication.shared.keyWindow?.rootViewController
            //downcast that rvc to a my mnc
            guard let homeNavController = rootViewController as? HomeNavigationController else {
                print("Not a Home Navigation Controller")
                return
            }
            let flowLayout = UICollectionViewFlowLayout()
            let homeController = HomeController(collectionViewLayout: flowLayout)
            homeController.user = user
            //archive the user
            UserDefaults.standard.archiveUser(user)
            homeNavController.viewControllers = [homeController]
            UserDefaults.standard.setIsLoggedIn(value: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func finishRegister(_ name: String, _ username:String, _ password:String) {
        Service.sharedInstance.fetchRegisterResult(name, username, password) { (reslt) in
            print("The result was:" , reslt)
            switch reslt{
            case false:
                let alert = UIAlertController(title: "Error", message: "An error was produced", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                
            case true:
                self.finishLoggingIn(username, password)
            }
        }
    }
    
    func loadAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - CollectionView Scroll Methods

extension LoginController {
    
    //hide keyboard
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //use when the keyboard has to go away no matter what
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //this is equal to the "page's number"
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        }else {
            pageControlBottomConstraint?.update(offset: 0)
            skipButtonTopConstraint?.update(offset: 16)
            nextButtonTopConstraint?.update(offset: 16)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
}


// MARK: - CollectionView Methods

extension LoginController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //if cell index = 3, which is the last one
        if indexPath.item == pages.count{
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: guideCellId, for: indexPath) as! GuideCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}


// MARK: - Observe Keyboard Methods

extension LoginController {
    
    //gotta check that keyboard to push the log in button a bit to the top ~30ish px
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
}


// MARK: - Aux Methods

extension LoginController {
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBottomConstraint?.update(offset: 40)
        skipButtonTopConstraint?.update(offset: -60)
        nextButtonTopConstraint?.update(offset: -60)
    }
    
    func registerCells() {
        collectionView.register(GuideCell.self, forCellWithReuseIdentifier: guideCellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
}
