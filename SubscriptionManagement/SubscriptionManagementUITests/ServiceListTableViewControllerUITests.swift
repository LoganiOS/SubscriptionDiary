//
//  ServiceListTableViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/20.
//

import XCTest
@testable import SubscriptionManagement

class ServiceListTableViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    private func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }
    
    private func given_presentServiceListTableViewController() {
        app.buttons[identifier(.plusButton)].tap()
    }
    
    func testLeftBarButton_whenTapped_didDismiss() {
        given_presentServiceListTableViewController()
        
        app.buttons[identifier(.leftBarButton)].tap()
        
        let exp = expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2)
        XCTAssertFalse(app.navigationBars[identifier(.serviceListTableViewNavigationBar)].exists)
    }
    
    func testSearchBar_whenSearchNetflix_didChangeCellCount() {
        given_presentServiceListTableViewController()
       
        let beforeCount = app.tables.firstMatch.cells.count
        
        let searchField = app.searchFields.firstMatch
        searchField.tap()
        searchField.typeText("netflix")
        
        let afterCount = app.tables.firstMatch.cells.count
        
        XCTAssertNotEqual(beforeCount, afterCount)
    }

}
