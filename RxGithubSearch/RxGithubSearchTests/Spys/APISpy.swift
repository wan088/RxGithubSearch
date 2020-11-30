//
//  APISpy.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/20.
//

import Foundation
import RxSwift

@testable import RxGithubSearch

class APISpy: APIProtocol {
    
    var stubbedSearchRepogitoriesResults: SearchRepogitoriesResults!
    var stubbedSearchUsersResults: SearchUsersResults!
    var stubbedError: ErrorDummy!
    var currentSearchType: SearchType!
    
    func getRepogitoriesResults(keyword: String, sort: RepoSorter, order: Order, completion: @escaping (SearchRepogitoriesResults?) -> Void) {
        self.currentSearchType = SearchType.repo
        if stubbedError != nil {
            completion(nil)
        }else{
            completion(stubbedSearchRepogitoriesResults)
        }
    }
    
    func getUsersResults (keyword: String, sort: RepoSorter, order: Order, completion: @escaping (SearchUsersResults?)->Void) {
        self.currentSearchType = SearchType.user
        if stubbedError != nil {
            completion(nil)
        }else{
            completion(stubbedSearchUsersResults)
        }
    }
    
    func rxGetRepositoriesResults(keyword: String, sort: RepoSorter, order: Order) -> Single<SearchRepogitoriesResults> {
        self.currentSearchType = SearchType.repo
        if let error = stubbedError {
            return Single.error(error)
        }else if let results = stubbedSearchRepogitoriesResults {
            return Single.just(results)
        } else {
            return Single.error(ErrorDummy())
        }
    }
    
    func rxGetUsersResults(keyword: String, sort: RepoSorter, order: Order) -> Single<SearchUsersResults> {
        self.currentSearchType = SearchType.user
        if let error = stubbedError {
            return Single.error(error)
        }else if let results = stubbedSearchUsersResults {
            return Single.just(results)
        } else {
            return Single.error(ErrorDummy())
        }
    }
    
}
