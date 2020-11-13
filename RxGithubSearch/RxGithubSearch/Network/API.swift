//
//  API.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/13.
//

import Foundation


enum RepoSorter: String {
    case stars
    case forks
    case helpWantedIssues = "help-wanted-Issues"
    case updated
}
enum Order {
    case desc
    case asc
}

class API {
    func getRepogitoriesResults (keyword: String, sort: RepoSorter?, order: Order?) {
        
    }
    
}
