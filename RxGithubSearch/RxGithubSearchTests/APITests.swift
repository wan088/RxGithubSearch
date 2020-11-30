//
//  APITests.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/11.
//

import Foundation
import XCTest
import RxSwift
@testable import RxGithubSearch

final class APITests: XCTestCase {
    
    let disposeBag = DisposeBag()
    override func setUp() {
        super.setUp()
    }
    
    func testSearchRepogitories_whenSuccess_get () {
        //given
        
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedResultsString = """
            {
              "total_count": 3,
              "incomplete_results": false,
              "items": [
                    {
                      "id": 26262860,
                      "node_id": "MDEwOlJlcG9zaXRvcnkyNjI2Mjg2MA==",
                      "name": "wangEditor",
                      "full_name": "wangeditor-team/wangEditor"
                    },
                    {
                      "id": 26262860,
                      "node_id": "MDEwOlJlcG9zaXRvcnkyNjI2Mjg2MA==",
                      "name": "wangEditor",
                      "full_name": "wangeditor-team/wangEditor"
                    },
                    {
                      "id": 26262860,
                      "node_id": "MDEwOlJlcG9zaXRvcnkyNjI2Mjg2MA==",
                      "name": "wangEditor",
                      "full_name": "wangeditor-team/wangEditor"
                    }
                ]
            }
        """
        
        let api = API(urlSession: urlSessionSpy)
        var myResult: SearchRepogitoriesResults?
        //when - getSerachRepogitories API 호출
        
        api.rxGetRepositoriesResults(keyword: "wan")
            .subscribe { (results) in
                myResult = results
            }.disposed(by: self.disposeBag)
        
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.1)
        //then
        XCTAssertNotNil(myResult)
        XCTAssertEqual(myResult!.total_count, 3)
        XCTAssertEqual(myResult!.items.first!.id, 26262860)
    }
    
    func testSearchRepogitories_whenNetworkFail_getNil () {
        //given
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedResultsString = """
            {
              "total_count": 3,
              "incomplete_results": false,
              "items": [
                    {
                      "id": 26262860,
                      "node_id": "MDEwOlJlcG9zaXRvcnkyNjI2Mjg2MA==",
                      "name": "wangEditor",
                      "full_name": "wangeditor-team/wangEditor"
                    },
                    {
                      "id": 26262860,
                      "node_id": "MDEwOlJlcG9zaXRvcnkyNjI2Mjg2MA==",
                      "name": "wangEditor",
                      "full_name": "wangeditor-team/wangEditor"
                    },
                    {
                      "id": 26262860,
                      "node_id": "MDEwOlJlcG9zaXRvcnkyNjI2Mjg2MA==",
                      "name": "wangEditor",
                      "full_name": "wangeditor-team/wangEditor"
                    }
                ]
            }
        """
        urlSessionSpy.stubbedError = ErrorDummy()
        let api = API(urlSession: urlSessionSpy)
        var myResult: SearchRepogitoriesResults? 
        
        //when - getSerachRepogitories API 호출
        
        api.rxGetRepositoriesResults(keyword: "wan")
            .subscribe { (results) in
                myResult = results
            }.disposed(by: self.disposeBag)
        
        
        //then
        XCTAssertNil(myResult)
    }
    
    func testSearchRepogitories_whenWrongDataFail_getNil () {
        //given
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedResultsString = "asdasd"
        let api = API(urlSession: urlSessionSpy)
        var myResult: SearchRepogitoriesResults?
        
        //when - getSerachRepogitories API 호출
        api.rxGetRepositoriesResults(keyword: "wan")
            .subscribe { (results) in
                myResult = results
            }.disposed(by: self.disposeBag)
        
        //then
        XCTAssertNil(myResult)
    }
    
    func testSearchUsers_whenSuccess_get () {
        //given
        
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedResultsString = """
            {
              "total_count": 12,
              "incomplete_results": false,
              "items": [
                {
                  "login": "mojombo",
                  "id": 1,
                  "node_id": "MDQ6VXNlcjE=",
                  "avatar_url": "https://secure.gravatar.com/avatar/25c7c18223fb42a4c6ae1c8db6f50f9b?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
                  "gravatar_id": "",
                  "url": "https://api.github.com/users/mojombo",
                  "html_url": "https://github.com/mojombo",
                  "followers_url": "https://api.github.com/users/mojombo/followers",
                  "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
                  "organizations_url": "https://api.github.com/users/mojombo/orgs",
                  "repos_url": "https://api.github.com/users/mojombo/repos",
                  "received_events_url": "https://api.github.com/users/mojombo/received_events",
                  "type": "User",
                  "score": 1.0
                }
              ]
            }
        """
        
        let api = API(urlSession: urlSessionSpy)
        var myResult: SearchUsersResults?
        
        //when - getSerachRepogitories API 호출
        api.rxGetUsersResults(keyword: "wan")
            .subscribe(onSuccess: { result in
            myResult = result
            }).disposed(by: self.disposeBag)
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.1)
        //then
        XCTAssertNotNil(myResult)
        XCTAssertEqual(myResult!.total_count, 12)
    }
}
