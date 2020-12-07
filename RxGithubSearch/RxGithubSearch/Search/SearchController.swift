//
//  GithubSearchViewController.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class SearchController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    var tableView: UITableView!
    var api: APIProtocol!
    
    let currentSearchType = BehaviorRelay<SearchType>(value: .repo)
    let repos = BehaviorRelay<[Repository]>(value: [])
    let users = BehaviorRelay<[User]>(value: [])
    let searchBarText = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        configureUI()
        addSubViews()
        self.reactor = SearchReactor(api: api)
    }
    
    func bind(reactor: SearchReactor) {
        
        self.navigationItem.rightBarButtonItem?
            .rx.tap
            .map{SearchReactor.Action.toggleSearchType}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map(\.searchType)
            .map{"\($0) _ Search"}
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        let currentSearchTypeObservable = self.currentSearchType.share()
    
        
        currentSearchTypeObservable
            .bind{ _ in self.tableView.reloadData() }
            .disposed(by: self.disposeBag)

        // TODO: distinctUntilChanged() 때문에 같은 키워드인데 서치타입이 다른 경우도 무시될 수 있다.
        // TODO: searchBar.text 자체를 옵저빙 하면서 테스트까지 할 수 있는 방법은 없을까?
        let searchBarChanged = self.searchBarText
            .filter{!$0.isEmpty}
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .share()
        
        searchBarChanged
            .filter{_ in return self.currentSearchType.value == .repo }
            .flatMap({(text) -> Single<[Repository]> in
                return self.api.getRepositoriesResults(keyword: text, sort: .stars, order: .asc)
                    .map{$0.items}
            })
            .bind(to: self.repos)
            .disposed(by:self.disposeBag)

        searchBarChanged
            .filter{_ in return self.currentSearchType.value == .user }
            .flatMap({(text) -> Single<[User]> in
                return self.api.getUsersResults(keyword: text, sort: .stars, order: .asc)
                    .map{$0.items}
            })
            .bind(to: self.users)
            .disposed(by:self.disposeBag)
        
        Observable<Any>.merge(self.repos.map{_ in ""}, self.users.map{_ in ""})
            .bind{[weak self]_ in self?.tableView.reloadData()}
            .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .bind{ [weak self] indexPath in
                let detail = UserDetailController()
                detail.index = indexPath.row
                self?.navigationController?.pushViewController(detail, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    func configureNavigationBar() {
        self.navigationItem.hidesSearchBarWhenScrolling = false
        let toggleSearchTypeBtn = UIBarButtonItem(systemItem: .organize)
        self.navigationItem.rightBarButtonItem = toggleSearchTypeBtn
    }
    
    func configureSearchBar() {
        let searchController = UISearchController()
        self.navigationItem.searchController = searchController
        self.navigationItem.searchController?.searchResultsUpdater = self
    }
    func configureTableView() {
        self.tableView = UITableView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        self.tableView.dataSource = self
    }
    
}
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchBarText.accept(searchController.searchBar.text ?? "")
    }
}
extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentSearchType.value {
        case .repo :
            return self.repos.value.count
        case .user :
            return self.users.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch self.currentSearchType.value {
        case .repo :
            cell.textLabel?.text = repos.value[indexPath.row].name
        case .user :
            cell.textLabel?.text = users.value[indexPath.row].login
        }
        
        return cell
    }
    
}
