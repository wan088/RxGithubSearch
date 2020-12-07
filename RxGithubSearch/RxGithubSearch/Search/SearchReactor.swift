//
//  SearchReactor.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/12/01.
//

import Foundation
import ReactorKit

class SearchReactor: Reactor {
    let initialState: State
    let api: APIProtocol
    
    enum Action {
        case toggleSearchType
        case search(String)
    }
    
    enum Mutation {
        case changeCurrentSearchType(SearchType)
        case updateDatas([Repository]?, [User]?)
    }
    
    struct State {
        var searchType: SearchType = .repo
        var repo: [Repository] = []
        var user: [User] = []
    }
    
    init(api: APIProtocol) {
        self.api = api
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleSearchType :
            return Observable.just(Mutation.changeCurrentSearchType(currentState.searchType.next))
        case let .search(keyword):
            switch self.currentState.searchType {
            case .repo :
                return api.getRepositoriesResults(keyword: keyword, sort: .stars, order: .asc)
                    .asObservable()
                    .map{Mutation.updateDatas($0.items, nil)}
            case .user :
                return api.getUsersResults(keyword: keyword, sort: .stars, order: .asc)
                    .asObservable()
                    .map{Mutation.updateDatas(nil, $0.items)}
            }
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .changeCurrentSearchType(type) :
            newState.searchType = type
        case let .updateDatas(repo, user) :
            if let repo = repo { newState.repo = repo }
            if let user = user { newState.user = user }
        }
        return newState
    }
}
