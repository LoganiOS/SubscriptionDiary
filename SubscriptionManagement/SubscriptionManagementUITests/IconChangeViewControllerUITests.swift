//
//  IconChangeViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/21.
//

import XCTest

class IconChangeViewControllerUITests: XCTestCase {

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
    
    func given_headToIconChangeViewController() {
        app.tables.firstMatch.cells.firstMatch.tap()
        app.buttons[identifier(.changeButton)].tap()
    }
    
    func testCollectionView_exists() {
        given_headToIconChangeViewController()
        
        let exp = expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 3)
        
        XCTAssertTrue(app.collectionViews[identifier(.iconCollectionView)].exists)
    }
    
    func testCollectionView_whenTappedCell_didDismiss() {
        given_headToIconChangeViewController()
        
        app.collectionViews.firstMatch.cells.firstMatch.tap()
        XCTAssertFalse(app.collectionViews[identifier(.iconCollectionView)].exists)
    }
    
}
