//
//  SearchTableViewController.swift
//  AudibleLike
//
//  Created by Gonzalo Reyes Huertas on 5/10/17.
//  Copyright © 2017 Gonzalo Reyes. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Object Variables
    
    var everyLostPeople: [Lost]!
    var filteredLostPeople: [Lost] = []
    var shouldShowSearchResults = false
    
    fileprivate let cellId = "cellId"
    
    
    // MARK: - Interface Objects
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Buscar personas"
        bar.delegate = self
        return bar
    }()
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = orangeColor
        
        self.navigationItem.titleView = searchBar
        
        tableView.register(FindPersonCell.self, forCellReuseIdentifier: cellId)
    }
    
}


// MARK: - ScrollView Methods

extension SearchTableViewController {
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}


// MARK: - TableView Methods

extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowSearchResults ? filteredLostPeople.count : everyLostPeople.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FindPersonCell
        let lostPerson = shouldShowSearchResults ? filteredLostPeople[indexPath.row] : everyLostPeople[indexPath.row]
        cell.lostPerson = lostPerson
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        let cell = tableView.cellForRow(at: indexPath) as! FindPersonCell
        let detailViewController = DetailViewController()
        detailViewController.lostPerson = cell.lostPerson
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


// MARK: - SearchBarDelegate Methods

extension SearchTableViewController {    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredLostPeople = everyLostPeople.filter({ (lost) -> Bool in
            let fullname = lost.firstname + " " + lost.lastname
            return ((fullname.lowercased().range(of: searchText.lowercased())) != nil)
        })
        if searchText != "" {
            shouldShowSearchResults = true
            tableView.reloadData()
        } else {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
    }
    
}
