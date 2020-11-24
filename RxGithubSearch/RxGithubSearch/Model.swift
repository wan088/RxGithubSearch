//
//  Model.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import Foundation

enum SearchType: Int {
    case repo
    case user
    
    var next: SearchType {
        Self(rawValue: self.rawValue + 1) ?? Self(rawValue: 0)!
    }
    
    var paramName: String {
        switch self {
        case .repo :
            return "repos"
        case .user :
            return "users"
        }
    }
}

struct SearchRepogitoriesResults: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repogitory]
}
struct Repogitory: Decodable, Equatable {  
    let id: Int
    let node_id: String
    let name: String
    let full_name: String
    // TODO : other properties
}


struct SearchUsersResults: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [User]
}

struct User: Decodable {
    let login: String
    let id: Int
    let node_id: String
}
