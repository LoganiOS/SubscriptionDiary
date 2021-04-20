//
//  SubscriptionStatusViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/15.
//

import XCTest
@testable import SubscriptionManagement

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
    
    private func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }
    
    private func given_whenTappedSortButton() {
        app.buttons[identifier(.sortButton)].tap()
    }
    
    private func given_whenTappedPlusButton() {
        app.buttons[identifier(.plusButton)].tap()
    }
    
    private func given_whenTappedSortByNameActionSheetButton(sortBy buttonTitle: String) {
        given_whenTappedSortButton()
        app.sheets.firstMatch.buttons["\(buttonTitle)"].tap()
    }

    func testSortButton_whenTapped_didPresentActionSheet() {
        given_whenTappedSortButton()

        XCTAssertTrue(app.sheets.firstMatch.exists)
    }
    
    func testActionSheet_whenTappedSortByNameButton_didDisMissFromViewController() {
        given_whenTappedSortByNameActionSheetButton(sortBy: "이름순")
        
        XCTAssertFalse(app.sheets.firstMatch.exists)
    }
        
    func testActionSheet_whenTappedSortByPaymentButton_didDisMissFromViewController() {
        given_whenTappedSortByNameActionSheetButton(sortBy: "결제금액순")
        
        XCTAssertFalse(app.sheets.firstMatch.exists)
    }
    
    func testActionSheet_whenTappedSortByPaymentDateButton_didDisMissFromViewController() {
        given_whenTappedSortByNameActionSheetButton(sortBy: "결제일순")
        
        XCTAssertFalse(app.sheets.firstMatch.exists)
    }

}
