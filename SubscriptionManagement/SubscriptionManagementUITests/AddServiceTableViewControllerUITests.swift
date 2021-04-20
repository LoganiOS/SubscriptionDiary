//
//  AddServiceTableViewControllerUITests.swift
//  SubscriptionManagementUITests
//
//  Created by LoganBerry on 2021/04/21.
//

import XCTest
@testable import SubscriptionManagement

class AddServiceTableViewControllerUITests: XCTestCase {

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
    
    // MARK:- add (직접추가)
    private func given_headToAddServiceTableViewControllerbyTappingRightBarButton() {
        app.buttons[identifier(.plusButton)].tap()
        app.buttons[identifier(.rightBarButton)].tap()
    }
    
    private func given_inputData() {
        let nameField = app.textFields[identifier(.nameField)]
        nameField.tap()
        nameField.typeText("테스트 서비스")
        
        app.buttons[identifier(.startDateButton)].tap()
        app.buttons[identifier(.selectStartDateButton)].tap()
        
        app.buttons[identifier(.renewalDateButton)].tap()
        app.buttons[identifier(.selectRenewalDateButton)].tap()
        
        app.switches[identifier(.pushSwith)].tap()
    }

    func test_headToAddServiceTableViewControllerbyTappingRightBarButton() {
        given_headToAddServiceTableViewControllerbyTappingRightBarButton()
        XCTAssertTrue(app.tables[identifier(.addServiceTableView)].exists)
    }
    
    func testAddNewService_whenTappedSaveButton_addNewService() {
        let beforeCount = app.tables.firstMatch.cells.count
        
        given_headToAddServiceTableViewControllerbyTappingRightBarButton()
        given_inputData()
        app.buttons[identifier(.saveButton)].tap()
        
        let exp = expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        let afterCount = app.tables.firstMatch.cells.count
        
        XCTAssertEqual(beforeCount + 1, afterCount)
    }
    
    // MARK:- update
    func testUpdateService_whenTappedBackButton_didPop() {
        app.tables.firstMatch.cells.firstMatch.tap()
        app.buttons[identifier(.backButton)].tap()
        
        XCTAssertFalse(app.tables[identifier(.addServiceTableView)].exists)
    }
    
    func testUpdateService_whenInputDataAndTappedBackButton_presentAlert() {
        app.tables.firstMatch.cells.firstMatch.tap()
        given_inputData()
        
        app.buttons[identifier(.backButton)].tap()
        
        XCTAssertTrue(app.alerts.firstMatch.exists)
    }
    
    func testDeleteButton_whenTappedDeleteButton_removedFromCell() {
        let beforeCount = app.tables.firstMatch.cells.count
        app.tables.firstMatch.cells.firstMatch.tap()
        
        app.buttons[identifier(.deleteServiceButton)].tap()
        app.buttons["삭제"].tap() // -> alert's button
        
        let exp = expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        let afterCount = app.tables.firstMatch.cells.count
        
        XCTAssertEqual(beforeCount, afterCount + 1)
    }
    
}
