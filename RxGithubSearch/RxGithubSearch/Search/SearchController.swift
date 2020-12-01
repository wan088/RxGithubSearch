//
//  GithubSearchViewController.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import UIKit
import RxSwift
import RxCocoa

class SearchController: UIViewController {
    let disposeBag = DisposeBag()
    
    var tableView: UITableView!
//    var repos = [Repogitory]()
//    var users = [User]()
//    var currentSearchType: SearchType = .repo
    var api: APIProtocol!
    
    let currentSearchType = BehaviorRelay<SearchType>(value: .repo)
    let repos = BehaviorRelay<[Repogitory]>(value: [])
    let users = BehaviorRelay<[User]>(value: [])
    let searchBarText = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        configureUI()
        addSubViews()
        bind()
    }
    
    func bind() {
        
        self.navigationItem.rightBarButtonItem?
            .rx.tap
            .withLatestFrom(currentSearchType)
            .map{$0.next}
            .bind(to: self.currentSearchType)
            .disposed(by: self.disposeBag)
        
        let currentSearchTypeObservable = self.currentSearchType.share()
        
        currentSearchTypeObservable
            .map{"\($0) _ Search"}
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        currentSearchTypeObservable
            .bind{ _ in self.tableView.reloadData() }
            .disposed(by: self.disposeBag)
        
        
        repos
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){(row, element, cell) in
                cell.textLabel?.text = element.name
            }
            .disposed(by: self.disposeBag)
        
        // TODO : searchBar.text 자체를 옵저빙 하면서 테스트까지 할 수 있는 방법은 없을까?
        self.searchBarText
            .filter{!$0.isEmpty}
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .debug()
            .flatMap({(text) -> Single<[Repogitory]> in
                print("?")
                return self.api.getRepositoriesResults(keyword: text, sort: .stars, order: .asc)
                    .map{$0.items}
            })
            .bind(to: self.repos)
            .disposed(by:self.disposeBag)

    }
    
    func configureNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        let toggleSearchTypeBtn = UIBarButtonItem(systemItem: .organize)
        self.navigationItem.rightBarButtonItem = toggleSearchTypeBtn
    }
    func configureSearchBar() {
        let searchController = UISearchController()
//        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    func configureTableView() {
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.tableView.dataSource = self
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
    
}
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchBarText.accept(searchController.searchBar.text ?? "")
    }
}
//extension SearchController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch self.currentSearchType {
//        case .repo :
//            return repos.count
//        case .user :
//            return users.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        switch self.currentSearchType {
//        case .repo:
//            cell.textLabel?.text = self.repos[indexPath.row].name
//        case .user:
//            cell.textLabel?.text = self.users[indexPath.row].login
//        }
//        return cell
//    }
////}
//extension SearchController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        switch self.currentSearchType {
//        case .repo:
//            self.api.getRepositoriesResults(keyword: searchController.searchBar.text ?? "", sort: .stars, order: .asc)
//                .subscribe(onSuccess: { (result) in
//                    self.repos = result.items
//                    self.tableView.reloadData()
//                })
//                .disposed(by: self.disposeBag)
//        case .user:
//            self.api.getUsersResults(keyword: searchController.searchBar.text ?? "", sort: .stars, order: .asc)
//                .subscribe(onSuccess: { (result) in
//                    self.users = result.items
//                    self.tableView.reloadData()
//                })
//                .disposed(by: self.disposeBag)
//        }
//    }
//}
