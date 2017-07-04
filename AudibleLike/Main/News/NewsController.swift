//
//  NewsController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 7/4/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {
    // MARK: - Object Ids
    private let cellId = "cellId"
    
    // MARK: - Object Variables
    var news: NewsFeed?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        setupNavBar()
        registerCells()
        fetchNewsFeed()       
    }
    
    // MARK: - Setup Methods
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = orangeColor
        navigationItem.title = "Noticias"
    }
    
    fileprivate func registerCells() {
        tableView.register(NewsCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func fetchNewsFeed() {
        Service.shared.fetchNewsFeed { (state) in
            switch state {
            case .failure(_):
                // TODO
                break
            case .success(let news):
                self.news = news
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NewsCell
        if let news = news?[indexPath.row] {
            cell.news = news
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetailController = NewsDetailController()
        if let news = news?[indexPath.row] {
            newsDetailController.news = news
        }
        navigationController?.pushViewController(newsDetailController, animated: true)
    }
}
