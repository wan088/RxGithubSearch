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
    
    func getRepositoriesResults (keyword: String, sort: RepoSorter = .updated, order: Order = .desc) -> Single<SearchRepogitoriesResults>{
        guard let urlRequest = buildRequest(path: "/repositories", parameters: [
            "q" : keyword,
            "sort" : sort.rawValue,
            "order" : order
        ]) else { return Single.error(APIError.normal) }
        return get(request: urlRequest)
    }
    func getUsersResults (keyword: String, sort: RepoSorter = .updated, order: Order = .asc) -> Single<SearchUsersResults>{
        guard let urlRequest = buildRequest(path: "/users", parameters: [
            "q" : keyword,
            "sort" : sort.rawValue,
            "order" : order
        ]) else { return Single.error(APIError.normal)}
        
        return get(request: urlRequest)
    }
    
    func get <T> (request: URLRequest) -> Single<T>  where T: Decodable {
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
    func getRepositoriesResults (keyword: String, sort: RepoSorter, order: Order) -> Single<SearchRepogitoriesResults>
    func getUsersResults (keyword: String, sort: RepoSorter, order: Order) -> Single<SearchUsersResults>
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
