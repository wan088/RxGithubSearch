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

class API: APIProtocol {
    
    private let baseUrl = "https://api.github.com/"
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func getRepogitoriesResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchRepogitoriesResults?)->Void) {
        
        let urlString = baseUrl + "search/repositories?q=\(keyword)&sort=\(sort!.rawValue)&order=\(order!)"
        guard let url = URL(string: urlString) else { return}
        urlSession.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if error != nil {
                completion(nil)
            }else if let data = data {
                let result = try? JSONDecoder().decode(SearchRepogitoriesResults.self, from: data)
                completion(result)
            }
        }.resume()
    }
}

extension URLSession: URLSessionProtocol {
    
}

protocol APIProtocol {
    func getRepogitoriesResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchRepogitoriesResults?)->Void)
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
