//
//  PaymentDateStatusViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/21.
//

import XCTest
@testable import SubscriptionManagement

class PaymentDateStatusViewControllerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDown() {
        app = nil
    }
    
    private func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }
    
    func testViewController_whenTappedSecondTabBarButton_displayPaymentDateStatusViewController() {
        app.buttons["모아보기"].tap()
        
        XCTAssertTrue(app.tables[identifier(.favoriteTableView)].exists)
    }
    
    func testCalendarView_whenSwipe_didChangeMonthLabel() {
        app.buttons["모아보기"].tap()
        
        let targetCell = app.tables.firstMatch.cells.firstMatch
        targetCell.swipeUp()
    }

}
