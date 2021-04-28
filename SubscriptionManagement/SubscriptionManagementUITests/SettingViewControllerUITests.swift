//
//  SettingViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/21.
//

import XCTest
@testable import SubscriptionManagement

class SettingViewControllerUITests: XCTestCase {

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

    func testTableView_whenTappedCell_goToColorSettingViewController() {
        app.buttons["설정"].tap() // Tabbar's Button
        app.tables.firstMatch.cells.firstMatch.tap()
        
        XCTAssertTrue(app.collectionViews[identifier(.colorCollectionView)].exists)
    }


}
