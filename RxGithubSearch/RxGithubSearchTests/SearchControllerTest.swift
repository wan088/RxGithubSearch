//
//  SearchControllerTest.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/20.
//

import XCTest

@testable import RxGithubSearch

class SearchControllerTest: XCTestCase {
    
    func testSearchResult_whenSuccess() {

    }
    
    func testSearchToggleBtn_whenTapped() {
        // given
        let controller = SearchController()
        controller.loadViewIfNeeded()
        let searchType = controller.currentSearchType
        
        // when + then
        controller.toggleSearchType(3)
        XCTAssertEqual(controller.title, "\(searchType.next()) _ Search")
        controller.toggleSearchType(3)
        XCTAssertEqual(controller.title, "\(searchType.next().next()) _ Search")
    }
}
