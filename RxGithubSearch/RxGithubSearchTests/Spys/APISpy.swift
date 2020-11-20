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
    var stubbedError: ErrorDummy!
    
    func getRepogitoriesResults(keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchRepogitoriesResults?) -> Void) {
        if stubbedError != nil {
            completion(nil)
        }else{
            completion(stubbedSearchRepogitoriesResults)
        }
    }
    
    
}
