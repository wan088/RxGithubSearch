//
//  GithubSearchViewController.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import UIKit
import RxSwift

class SearchController: UIViewController {
    let disposeBag = DisposeBag()
    
    var tableView: UITableView!
    var repos = [Repogitory]()
    var users = [User]()
    var currentSearchType: SearchType = .repo
    var api: APIProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        configureUI()
        addSubViews()
    }
    
    func bind() {
        
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
        self.currentSearchType = self.currentSearchType.next
        self.title = "\(self.currentSearchType) _ Search"
    }
}
extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentSearchType {
        case .repo :
            return repos.count
        case .user :
            return users.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch self.currentSearchType {
        case .repo:
            cell.textLabel?.text = self.repos[indexPath.row].name
        case .user:
            cell.textLabel?.text = self.users[indexPath.row].login
        }
        return cell
    }
}
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        switch self.currentSearchType {
        case .repo:
            self.api.rxGetRepositoriesResults(keyword: searchController.searchBar.text ?? "", sort: .stars, order: .asc)
                .subscribe(onSuccess: { (result) in
                    self.repos = result.items
                    self.tableView.reloadData()
                })
                .disposed(by: self.disposeBag)
        case .user:
            self.api.rxGetUsersResults(keyword: searchController.searchBar.text ?? "", sort: .stars, order: .asc)
                .subscribe(onSuccess: { (result) in
                    self.users = result.items
                    self.tableView.reloadData()
                })
                .disposed(by: self.disposeBag)
        }
    }
}
