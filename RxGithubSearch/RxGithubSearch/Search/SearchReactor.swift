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
    }
    
    enum Mutation {
        case changeCurrentSearchType(SearchType)
    }
    
    struct State {
        var searchType: SearchType = .repo
    }
    
//            .withLatestFrom(currentSearchType)
//            .map{$0.next}
//            .bind(to: self.currentSearchType)
//            .disposed(by: self.disposeBag)
    
    init(api: APIProtocol) {
        self.api = api
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .toggleSearchType :
            return Observable.just(Mutation.changeCurrentSearchType(currentState.searchType.next))
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .changeCurrentSearchType(type) :
            newState.searchType = type
            print(type)
        }
        return newState
    }
}
