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
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    var api: APIProtocol!
    
    let searchBarText = PublishRelay<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.reactor = SearchReactor(api: api)
        addSubViews()
    }
    
    func bind(reactor: SearchReactor) {
        
        self.navigationItem.rightBarButtonItem?
            .rx.tap
            .map{SearchReactor.Action.toggleSearchType}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.navigationItem.searchController?.searchBar
            .rx.text
            .filter{$0 != nil && !$0!.isEmpty}
            .map{$0!}
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map{SearchReactor.Action.search($0)}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
//        reactor.state
//            .map(\.isLoading)
//            .
        
        reactor.state
            .map(\.searchType)
            .map{"\($0) _ Search"}
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map(\.items)
            .bind(to: self.tableView.rx.items){(tableView, row, item) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: IndexPath(row: row, section: 0))
                if let item = item as? Repository {
                    cell.textLabel?.text = item.name
                }else if let item = item as? User {
                    cell.textLabel?.text = item.login
                }
                return cell
            }
            .disposed(by: self.disposeBag)

        tableView.rx.itemSelected
            .bind{ [weak self] indexPath in
                let detail = UserDetailController()
                detail.index = indexPath.row
                self?.navigationController?.pushViewController(detail, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        let toggleSearchTypeBtn = UIBarButtonItem(systemItem: .organize)
        self.navigationItem.rightBarButtonItem = toggleSearchTypeBtn
        
        let searchController = UISearchController()
        self.navigationItem.searchController = searchController
    }
    func addSubViews() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        self.tableView.addSubview(activityIndicator)
    }
    
}
