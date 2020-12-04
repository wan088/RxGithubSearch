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
    
    var stubbedSearchRepositoriesResults: SearchRepositoriesResults!
    var stubbedSearchUsersResults: SearchUsersResults!
    var stubbedError: ErrorDummy!
    var currentSearchType: SearchType!
    
    func getRepositoriesResults(keyword: String, sort: RepoSorter, order: Order) -> Single<SearchRepositoriesResults> {
        self.currentSearchType = SearchType.repo
        if let error = stubbedError {
            return Single.error(error)
        }else if let results = stubbedSearchRepositoriesResults {
            return Single.just(results)
        } else {
            return Single.error(ErrorDummy())
        }
    }
    
    func getUsersResults(keyword: String, sort: RepoSorter, order: Order) -> Single<SearchUsersResults> {
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
