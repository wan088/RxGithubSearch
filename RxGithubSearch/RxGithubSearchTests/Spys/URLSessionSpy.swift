//
//  URLSessionSpy.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/18.
//

import Foundation

@testable import RxGithubSearch

class URLSessionSpy: URLSessionProtocol {
    var stubbedSearchRepositoriesResultsString: String!
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = stubbedSearchRepositoriesResultsString.data(using: .utf8)
        completionHandler(data, nil, nil)
        return URLSessionDataTaskDummy()
    }
}

class URLSessionDataTaskDummy: URLSessionDataTask {
    override func resume() {
    }
}