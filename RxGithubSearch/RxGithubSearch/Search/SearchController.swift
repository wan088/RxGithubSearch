//
//  GithubSearchViewController.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import UIKit

enum SearchType: Int {
    case repo
    case user
    
    func next() -> SearchType {
        let nextIdx = self.rawValue + 1
        return Self(rawValue: nextIdx) ?? Self(rawValue: 0)!
    }
}
class SearchController: UIViewController {
    var tableView: UITableView!
    var repos = [Repogitory]()
    var currentSearchType: SearchType = .repo
    var api: APIProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        configureUI()
        addSubViews()
    }
    func configureNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        let toggleSearchTypeBtn = UIBarButtonItem(barButtonSystemItem: .organize, target:  self, action: #selector(toggleSearchType(_:)))
        self.navigationItem.rightBarButtonItem = toggleSearchTypeBtn
    }
    func configureSearchBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    func configureTableView() {
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
    }
    func configureUI() {
        self.view.backgroundColor = .white
        self.title = "\(self.currentSearchType) _ Search"
    }
    func addSubViews() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    
    @objc
    func toggleSearchType(_ sender: Any) {
        self.currentSearchType = self.currentSearchType.next()
        self.title = "\(self.currentSearchType) _ Search"
    }
}
extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.repos[indexPath.row].name
        return cell
    }
}
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.api.getRepogitoriesResults(keyword: searchController.searchBar.text ?? "", sort: .stars, order: .asc) { (result) in
            DispatchQueue.main.async {
                self.repos = result?.items ?? []
                self.tableView.reloadData()
            }
        }
    }
}
