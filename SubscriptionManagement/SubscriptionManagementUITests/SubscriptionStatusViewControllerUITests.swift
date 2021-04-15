//
//  SubscriptionStatusViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/15.
//

import XCTest

class SubscriptionStatusViewControllerUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    private func given_whenTappedSortButton() {
        app.buttons["SortButton"].tap()
    }
    
    private func given_whenTappedAddButton() {
        app.buttons["Add"].tap()
    }
    
    private func given_whenTappedSortByNameActionSheetButton(sortBy buttonTitle: String) {
        app.buttons["SortButton"].tap()
        app.sheets.firstMatch.buttons["\(buttonTitle)"].tap()
    }

    func testSubscriptionStatusViewController_whenTappedSortButton_didPresentActionSheet() {
        given_whenTappedSortButton()

        XCTAssertTrue(app.sheets.firstMatch.exists)
    }
    
    func testSubscriptionStatusViewController_whenTappedSortByNameActionSheetButton_didDisMissFromViewController() {
        given_whenTappedSortByNameActionSheetButton(sortBy: "이름순")
        
        XCTAssertFalse(app.sheets.firstMatch.exists)
    }
        
    func testSubscriptionStatusViewController_whenTappedSortByPaymentActionSheetButton_didDisMissFromViewController() {
        given_whenTappedSortByNameActionSheetButton(sortBy: "결제금액순")
        
        XCTAssertFalse(app.sheets.firstMatch.exists)
    }
    
    func testSubscriptionStatusViewController_whenTappedSortByPaymentDateActionSheetButton_didDisMissFromViewController() {
        given_whenTappedSortByNameActionSheetButton(sortBy: "결제일순")
        
        XCTAssertFalse(app.sheets.firstMatch.exists)
    }

    func testSubscriptionStatusViewController_whenTappedAddButton_presentServiceListTableViewController() {
        given_whenTappedAddButton()
        
        XCTAssertTrue(app.navigationBars["서비스 목록"].exists) 
    }


    
    
}
