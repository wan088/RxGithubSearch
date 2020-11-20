//
//  APITests.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/11.
//

import Foundation
import XCTest

@testable import RxGithubSearch

final class APITests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testSearchRepogitories_whenSuccess_get () {
        //given
        
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedSearchRepositoriesResultsString = """
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
        
        api.getRepogitoriesResults(keyword: "wan", sort: .stars, order: .asc) { result in
            myResult = result
        }
        
        //then
        XCTAssertNotNil(myResult)
        XCTAssertEqual(myResult!.total_count, 3)
    }
    
    func testSearchRepogitories_whenNetworkFail_getNil () {
        //given
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedSearchRepositoriesResultsString = """
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
        var myResult: SearchRepogitoriesResults! = SearchRepogitoriesResults(total_count: 3, incomplete_results: true, items: [])
        
        //when - getSerachRepogitories API 호출
        
        let result = api.getRepogitoriesResults(keyword: "wan", sort: .stars, order: .asc) { (result) in
            myResult = result
        }
        
        //then
        XCTAssertNil(myResult)
    }
    
    func testSearchRepogitories_whenWrongDataFail_getNil () {
        //given
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedSearchRepositoriesResultsString = "asdasd"
        let api = API(urlSession: urlSessionSpy)
        var myResult: SearchRepogitoriesResults! = SearchRepogitoriesResults(total_count: 3, incomplete_results: true, items: [])
        
        //when - getSerachRepogitories API 호출
        api.getRepogitoriesResults(keyword: "asda", sort: .stars, order: .asc) { (result) in
            myResult = result
        }
        
        //then
        XCTAssertNil(myResult)
    }
    
    func testSearchUsers_whenSuccess_get () {
        //given
        
        let urlSessionSpy = URLSessionSpy()
        urlSessionSpy.stubbedSearchUsersResultsString = """
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
        var myResult: SearchUsersResults?
        
        //when - getSerachRepogitories API 호출
        api.getUsersResults(keyword: "wan", sort: .stars, order: .asc) { result in
            myResult = result
        }
        
        //then
        XCTAssertNotNil(myResult)
        XCTAssertEqual(myResult!.total_count, 3)
    }
}
