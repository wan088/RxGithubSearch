//
//  API.swift
//  RxGithubSearch
//
//  Created by rookie.w on 2020/11/13.
//

import Foundation
import RxSwift

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
enum APIError: Error {
    case normal
}
class API: APIProtocol {
    
    private let baseUrl = "https://api.github.com/search"
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func getRepogitoriesResults (keyword: String, sort: RepoSorter = .updated, order: Order = .desc, completion: @escaping (SearchRepogitoriesResults?)->Void) {
        guard let urlRequest = buildRequest(path: "/repositories", parameters: [
            "q" : keyword,
            "sort" : sort.rawValue,
            "order" : order
        ]) else {return}
        
        getResults(request: urlRequest, completion: completion)
    }
    
    func rxGetRepositoriesResults (keyword: String, sort: RepoSorter = .updated, order: Order = .desc) -> Single<SearchRepogitoriesResults>{
        guard let urlRequest = buildRequest(path: "/repositories", parameters: [
            "q" : keyword,
            "sort" : sort.rawValue,
            "order" : order
        ]) else { return Single.error(APIError.normal) }
        return rxGetResults(request: urlRequest)
    }
    
    func getUsersResults (keyword: String, sort: RepoSorter = .updated, order: Order = .asc, completion: @escaping (SearchUsersResults?)->Void) {
        guard let urlRequest = buildRequest(path: "/users", parameters: [
            "q" : keyword,
            "sort" : sort.rawValue,
            "order" : order
        ]) else {return}
        
        getResults(request: urlRequest, completion: completion)
    }
    func rxGetUsersResults (keyword: String, sort: RepoSorter = .updated, order: Order = .asc) -> Single<SearchUsersResults>{
        guard let urlRequest = buildRequest(path: "/users", parameters: [
            "q" : keyword,
            "sort" : sort.rawValue,
            "order" : order
        ]) else { return Single.error(APIError.normal)}
        
        return rxGetResults(request: urlRequest)
    }
    
    func getResults <T> (request: URLRequest, completion: @escaping (T?)->Void) where T: Decodable {
        urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil)
            }else if let data = data {
                let result = try? JSONDecoder().decode(T.self, from: data)
                completion(result)
            }
        }.resume()
    }
    
    func rxGetResults <T> (request: URLRequest) -> Single<T>  where T: Decodable {
        return Single.create { observer -> Disposable in
            let dataTask = self.urlSession.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer(.error(error))
                }else if let data = data, let result = try? JSONDecoder().decode(T.self, from: data) {
                    observer(.success(result))
                }else {
                    observer(.error(APIError.normal))
                }
            }
            dataTask.resume()
            return Disposables.create { dataTask.cancel() }
        }.observeOn(MainScheduler.asyncInstance)
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
    func getRepogitoriesResults (keyword: String, sort: RepoSorter, order: Order, completion: @escaping (SearchRepogitoriesResults?)->Void)
    func getUsersResults (keyword: String, sort: RepoSorter, order: Order, completion: @escaping (SearchUsersResults?)->Void)
    func rxGetRepositoriesResults (keyword: String, sort: RepoSorter, order: Order) -> Single<SearchRepogitoriesResults>
    func rxGetUsersResults (keyword: String, sort: RepoSorter, order: Order) -> Single<SearchUsersResults>
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
