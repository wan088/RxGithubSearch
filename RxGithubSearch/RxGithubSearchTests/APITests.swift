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
        
        let stubbed: [Repogitory] = []
        //when - getSerachRepogitories API 호출
        
        let result: SearchRepogitoriesResults? = nil
        //then
        XCTAssertNotNil(result)
        XCTAssertEqual(result!.items, stubbed)
        
    }
}
