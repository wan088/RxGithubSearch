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
    
    func testSearchRepogitories_whenSuccess () {
        //given
        
        let stubbedResults: [String : Any]?
        //when - getSerachRepogitories API 호출
        
        let result: SearchRepogitoriesResults? = nil
        
        //then
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.total_count, 5)
    }
    
    func testSearchRepogitories_whenNetworkFail_getNil () {
        //given
        
        let stubbedResults: [String : Any]?
        //when - getSerachRepogitories API 호출
        
        let result: SearchRepogitoriesResults? = nil
        
        //then
        XCTAssertNil(result)
    }
    
    func testSearchRepogitories_whenWrongDataFail_getNil () {
        //given
        
        let stubbedResults: [String : Any]?
        //when - getSerachRepogitories API 호출
        
        let result: SearchRepogitoriesResults? = nil
        
        //then
        XCTAssertNil(result)
    }
}
