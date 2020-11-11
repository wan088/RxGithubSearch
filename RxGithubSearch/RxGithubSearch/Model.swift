//
//  Model.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/11.
//

import Foundation

struct SearchRepogitoriesResults: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let itmes: [Repogitory]
}
struct Repogitory: Decodable { 
    let id: Int
    let node_id: String
    let name: String
    let full_name: String
    // TODO : other properties
}

