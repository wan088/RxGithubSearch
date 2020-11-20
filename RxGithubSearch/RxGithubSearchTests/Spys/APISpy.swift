//
//  APISpy.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/20.
//

import Foundation

@testable import RxGithubSearch

class APISpy: APIProtocol {
    var stubbedSearchRepogitoriesResults: SearchRepogitoriesResults!
    var stubbedSearchUsersResults: SearchUsersResults!
    var stubbedError: ErrorDummy!
    var currentSearchType: SearchType!
    
    func getRepogitoriesResults(keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchRepogitoriesResults?) -> Void) {
        self.currentSearchType = SearchType.repo
        if stubbedError != nil {
            completion(nil)
        }else{
            completion(stubbedSearchRepogitoriesResults)
        }
    }
    
    func getUsersResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchUsersResults?)->Void) {
        self.currentSearchType = SearchType.user
        if stubbedError != nil {
            completion(nil)
        }else{
            completion(stubbedSearchUsersResults)
        }
    }
    
    
}
