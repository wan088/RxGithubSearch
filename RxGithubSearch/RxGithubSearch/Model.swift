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

struct SearchRepositoriesResults: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [Repository]
}
struct Repository: Decodable, Equatable, SearchResultItem {
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

struct User: Decodable, SearchResultItem {
    let login: String
    let id: Int
    let node_id: String
    
}

protocol SearchResultItem {
}
