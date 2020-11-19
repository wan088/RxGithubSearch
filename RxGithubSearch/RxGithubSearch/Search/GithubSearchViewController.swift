//
//  GithubSearchViewController.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import UIKit

class GithubSearchViewController: UIViewController {
    var tableView: UITableView!
    var repos = [Repogitory]()
    
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
    }
    func configureSearchBar() {
        let searchController = UISearchController()
        self.navigationItem.searchController = searchController
    }
    func configureTableView() {
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
    }
    func configureUI() {
        self.view.backgroundColor = .white
        self.title = "GitSearch"
    }
    func addSubViews() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
}
extension GithubSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
//        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "a"
        return cell
    }
}
