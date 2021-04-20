//
//  AddServiceTableViewControllerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/20.
//

import XCTest
@testable import SubscriptionManagement

class AddServiceTableViewControllerTests: XCTestCase {

    var nav: UINavigationController!
    var sut: AddServiceTableViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "AddServiceTableViewController") as? AddServiceTableViewController
        
        sut.loadViewIfNeeded()
        nav = UINavigationController(rootViewController: sut)
    }
    
    override func tearDownWithError() throws {
        nav = nil
        sut = nil
    }
    
    // MARK:- viewDidLoad
    func testServiceNameTextField_whenViewDidLoad_returnKeyTypeIsDone() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.serviceNameTextField.returnKeyType == .done)
    }
    
    func testPaymentTextField_whenViewDidLoad_returnKeyTypeIsDone() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.paymentTextField.returnKeyType == .done)
    }
    
    func testIndex_whenViewDidLoad_isEqualToUserDefaultValue() {
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.index, UserDefaults.standard.integer(forKey: "selectedIndex"))
    }
    
    func testSavedService_whenSavedServiceIsNotNil_setControllProperty() {
        sut.savedService = SavedServiceEntity(context: sut.coreDataManager.mainContext)
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.saveButton.isEnabled)
        XCTAssertEqual(sut.saveButton.titleLabel?.text, "저장")
        XCTAssertEqual(sut.selectedCategory, sut.savedService?.category)
        XCTAssertEqual(sut.serviceNameTextField.text, sut.savedService?.koreanName ?? "")
        XCTAssertEqual(sut.subscriptionNotificationStatusSwitch.isOn, sut.savedService?.notificationIsOn)
        XCTAssertEqual(sut.serviceEnglishNameText, sut.savedService?.englishName ?? "")
    }
    
    // MARK:- viewWillDisappear(_:)
    func testTextFields_whenViewWillDisappear_textFieldsResignFirstResponder() {
        sut.viewDidLoad()
        sut.viewWillDisappear(true)
        
        XCTAssertFalse(sut.paymentTextField.isFirstResponder)
        XCTAssertFalse(sut.serviceNameTextField.isFirstResponder)
    }
    
    // MARK:- when called selectCategory method
    func testSelectCategory_whenCalledThisMethod_textFieldsResignFirstResponder() {
        sut.viewDidLoad()
        
        sut.selectCategory(sut as Any)
        
        XCTAssertFalse(sut.paymentTextField.isFirstResponder)
        XCTAssertFalse(sut.serviceNameTextField.isFirstResponder)
    }
    
    // MARK:- when called save method
    func testSave_whenSavedServiceIsNotNil_savedServiceEntityIsUpdated() {
        // given
        sut.coreDataManager = MockCoreDataManager()
        sut.viewDidLoad()
        
        sut.savedService = SavedServiceEntity(context: sut.coreDataManager.mainContext)
        sut.savedService?.koreanName = "유튜브 프리미엄"
        sut.savedService?.amountOfPayment = "10000"
        
        sut.serviceNameTextField.text = "넷플릭스"
        sut.paymentTextField.text = "90000"
        
        // when
        sut.save(sut as Any)
        
        // then
        XCTAssertTrue(sut.savedService?.koreanName == "넷플릭스")
        XCTAssertTrue(sut.savedService?.amountOfPayment == "90000")
    }
    
    func testSave_whenNoNameAndNoPaymentAndSavedServiceIsNil_savedServiceEntityIsAdded() {
        // given
        sut.coreDataManager = MockCoreDataManager()
        sut.viewDidLoad()
        
        // when
        sut.save(sut as Any)
        
        // then
        XCTAssertTrue(sut.coreDataManager.list.first?.koreanName == "이름없는 서비스")
        XCTAssertTrue(sut.coreDataManager.list.first?.amountOfPayment == "0".numberFormattedString(.currency))
    }
    
    func testSave_whenThereIsNameAndPaymentAndSavedServiceIsNil_savedServiceEntityIsAdded() {
        // given
        sut.coreDataManager = MockCoreDataManager()
        sut.viewDidLoad()
        
        sut.serviceNameTextField.text = "넷플릭스"
        sut.paymentTextField.text = "193894"
        
        // when
        sut.save(sut as Any)
        
        // then
        XCTAssertTrue(sut.coreDataManager.list.first?.koreanName == "넷플릭스")
        XCTAssertTrue(sut.coreDataManager.list.first?.amountOfPayment == "193894")
    }
 

}
