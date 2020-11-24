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
    
    private let baseUrl = "https://api.github.com/search"
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func getRepogitoriesResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchRepogitoriesResults?)->Void) {
        guard let urlRequest = buildRequest(path: "/repositories", parameters: [
            "q" : keyword,
            "sort" : sort!.rawValue,
            "order" : order!
        ]) else {return}
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(nil)
            }else if let data = data {
                let result = try? JSONDecoder().decode(SearchRepogitoriesResults.self, from: data)
                completion(result)
            }
        }.resume()
    }
    func getUsersResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchUsersResults?)->Void) {
        guard let urlRequest = buildRequest(path: "/users", parameters: [
            "q" : keyword,
            "sort" : sort!.rawValue,
            "order" : order!
        ]) else {return}
        
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(nil)
            }else if let data = data {
                let result = try? JSONDecoder().decode(SearchUsersResults.self, from: data)
                completion(result)
            }
        }.resume()
        
    }
    
    private func buildRequest(path: String, parameters: [String : Any] = [:]) -> URLRequest? {
        var components = URLComponents(string: baseUrl + path)
        components?.queryItems = parameters.map{
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        guard let url = components?.url else {return nil}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Content-Type" : "application/json"]
        
        return request
    }
}

extension URLSession: URLSessionProtocol {
    
}

protocol APIProtocol {
    func getRepogitoriesResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchRepogitoriesResults?)->Void)
    func getUsersResults (keyword: String, sort: RepoSorter?, order: Order?, completion: @escaping (SearchUsersResults?)->Void)
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
