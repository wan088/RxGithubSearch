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
        self.controller.navigationItem.searchController?.searchBar.text = "wan"
        self.controller.updateSearchResults(for: controller.navigationItem.searchController!)
        
        // then
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 1)
        XCTAssertEqual(controller.tableView.numberOfRows(inSection: 0), 3)
        XCTAssertEqual(controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text, "dfg")
    }
    
    func testSearchResult_whenToggled() {
        // given
        let searchType = controller.currentSearchType
        api.currentSearchType = searchType.value
        api.stubbedSearchRepositoriesResults = SearchRepositoriesResults(total_count: 5, incomplete_results: true, items: [Repository(id: 32, node_id: "asd", name: "kyw", full_name: "yongwan")])
        api.stubbedSearchUsersResults = SearchUsersResults(total_count: 3, incomplete_results: true, items: [User(login: "lee", id: 123, node_id: "leewan")])
        
        self.controller.view.layoutIfNeeded()
        
        //when + then
        self.controller.navigationItem.searchController?.searchBar.text = "asd"
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.4)
        XCTAssertTrue(controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text?.contains("kyw") == true)
        
        self.controller.currentSearchType.accept(.user)
        
        self.controller.navigationItem.searchController?.searchBar.text = "my"
        XCTWaiter().wait(for: [XCTestExpectation()], timeout: 0.4)
        XCTAssertTrue(controller.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.textLabel?.text?.contains("lee") == true)
    }
    
    
    func testSearchToggleBtn_whenTapped() {
        // given
        let controller = SearchController()
        controller.loadViewIfNeeded()
        let searchType = controller.currentSearchType
        
        // when + then
        controller.currentSearchType.accept(.user)
        XCTAssertEqual(controller.title, "\(searchType.value.next) _ Search")
        controller.currentSearchType.accept(.repo)
        XCTAssertEqual(controller.title, "\(searchType.value.next.next) _ Search")
    }
    
    
}
