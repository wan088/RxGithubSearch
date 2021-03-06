//
//  SearchControllerTest.swift
//  RxGithubSearchTests
//
//  Created by rookie.w on 2020/11/20.
//

import XCTest
import RxSwift
import RxCocoa

@testable import RxGithubSearch

class SearchControllerTest: XCTestCase {
    
    var controller: SearchController!
    var api: APISpy!
    
    override func setUp() {
        super.setUp()
        self.controller = SearchController()
        self.api = APISpy()
        self.controller.api = self.api
        
        
    }
    func testSearchResult_whenSuccess() {
        // given
        self.api.stubbedSearchRepositoriesResults = SearchRepositoriesResults(
            total_count: 3,
            incomplete_results: true,
            items: [
                Repository(id: 1, node_id: "id1", name: "dfg", full_name: "dfg"),
                Repository(id: 2, node_id: "id2", name: "dfggd", full_name: "dfg"),
                Repository(id: 3, node_id: "id3", name: "dfgfs", full_name: "dfg"),
            ]
        )
        self.controller.loadViewIfNeeded()
        
        // when
        self.controller.reactor?.action.on(.next(.search("wan")))
        // then
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 1)
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 3)
        XCTAssertEqual(controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, "dfg")
    }
    
    func testSearchResult_whenToggled() {
        // given
        api.currentSearchType = controller.reactor?.currentState.searchType
        api.stubbedSearchRepositoriesResults = SearchRepositoriesResults(total_count: 5, incomplete_results: true, items: [Repository(id: 32, node_id: "asd", name: "kyw", full_name: "yongwan")])
        api.stubbedSearchUsersResults = SearchUsersResults(total_count: 3, incomplete_results: true, items: [User(login: "lee", id: 123, node_id: "leewan")])
        
        self.controller.view.layoutIfNeeded()
        
        //when + then
        self.controller.reactor?.action.on(.next(.search("asd")))
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.4)
        XCTAssertTrue(controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text?.contains("kyw") == true)
        
        self.controller.reactor?.action.on(.next(.toggleSearchType))
        
        self.controller.reactor?.action.on(.next(.search("my")))
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.4)
        XCTAssertTrue(controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text?.contains("lee") == true)
    }
    
    // TODO : 해당 테스트를 위한 차후 추가작업 필요
//    func testSearchToggleBtn_whenTapped() {
//        // given
//        let controller = SearchController()
//        controller.loadViewIfNeeded()
//        let searchType = controller.currentSearchType
//
//        // when + then
//        controller.currentSearchType.accept(.user)
//        XCTAssertEqual(controller.title, "\(searchType.value.next) _ Search")
//        controller.currentSearchType.accept(.repo)
//        XCTAssertEqual(controller.title, "\(searchType.value.next.next) _ Search")
//    }
    
    
}
