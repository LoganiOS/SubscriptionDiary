//
//  SubscriptionStatusViewControllerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/11.
//

import XCTest
@testable import SubscriptionManagement

class SubscriptionStatusViewControllerTests: XCTestCase {
    
    var nav: UINavigationController!
    var tab: UITabBarController!
    var sut: SubscriptionStatusViewController!
    
    private let categories = ["OTT", "음악", "사무", "기타"]
    private let names = [("넷플릭스", "netflix"), ("유튜브 프리미엄", "youtube premium"), ("플로", "flo"), ("어도비 XD","adobe XD")]
    private let renewalDates = ["1주", "2주", "1개월", "2개월"]
    
    private func givenTestServices(repeating count: Int) {
        for _ in 1...count {
            let n = Int.random(in: 0...3)
            
            sut.coreDataManager.add(category: categories[n],
                    name: names[n].0,
                    englishName: names[n].1,
                    imageURLString: "",
                    payment: "\(n + 10000)",
                    startDate: Date(),
                    renewalDate: renewalDates[n],
                    pushOn: true)
        }
    }
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "SubscriptionStatusViewController") as? SubscriptionStatusViewController
        
        sut.loadViewIfNeeded()
        nav = UINavigationController(rootViewController: sut)
        tab = UITabBarController()
        
        tab.addChild(nav)
        
        sut.coreDataManager = MockCoreDataManager()
    }
    
    override func tearDownWithError() throws {
        nav = nil
        sut = nil
    }
    
    func testSortedServices_whenInit_sortServicesEqualsCOreDataManagerList() {
        XCTAssertEqual(sut.sortedServices, sut.coreDataManager.list)
    }
    
    // MARK: - viewDidLoad
    func testDefaultSubscriptionStatusLabel_whenViewDidLoad_defaultSubscriptionStatusLabelIsAddedToSubviews () {
        sut.viewDidLoad()
        
        let labelIsAdded = sut.view.subviews.contains(sut.defaultSubscriptionStatusLabel)
        XCTAssertTrue(labelIsAdded)
    }
    
    func testDefaultSubscriptionStatusLabel_whenViewDidLoadAndCoreDataListIsEmpty_defaultSubscriptionStatusLabelIsNotHidden() {
        
        sut.viewDidLoad()
        
        XCTAssertEqual(String(format: "%.1f", sut.defaultSubscriptionStatusLabel.alpha), "0.3")
        XCTAssertFalse(sut.defaultSubscriptionStatusLabel.isHidden)
    }
    
    func testDefaultSubscriptionStatusLabel_whenViewDidLoadAndCoreDataListIsNotEmpty_defaultSubscriptionStatusLabelIsHidden() {
        givenTestServices(repeating: 5)

        sut.viewDidLoad()

        XCTAssertEqual(String(format: "%.1f", sut.defaultSubscriptionStatusLabel.alpha), "0.0")
        XCTAssertTrue(sut.defaultSubscriptionStatusLabel.isHidden)
    }
    
    private func givenNotification_whenViewDidLoad(name post: Notification.Name) {
        sut.viewDidLoad()
        
        let exp = expectation(forNotification: .serviceDidAdd, object: nil, handler: nil)
        exp.fulfill()
        
        wait(for: [exp], timeout: 1)
    }
    
    func testAddObserver_whenViewDidLoadAndDidPostServiceDidAdd_didAddUserNotification() {
        givenNotification_whenViewDidLoad(name: .serviceDidAdd)
    }
    
    func testAddObserver_whenViewDidLoadAndDidPostServiceDidUpdate_didAddUserNotification() {
        givenNotification_whenViewDidLoad(name: .serviceDidUpdate)
    }
    
    func testAddObserver_whenViewDidLoadAndDidPostServiceDidDelete_didNotAddUserNotification() {
        givenNotification_whenViewDidLoad(name: .serviceDidDelete)
    }
    
    // MARK: - viewWillAppear
    func testAddObserver_whenViewWillAppearAndCoreDataManagerListIsEmpty_returns() {
        sut.viewWillAppear(true)
        
        XCTAssertTrue(sut.coreDataManager.list.isEmpty)
    }
    
    func testAddObserver_whenViewWillAppearAndCoreDataManagerListIsNotEmpty_calculatePaymentDays() {
        givenTestServices(repeating: 1)

        sut.viewWillAppear(true)
        XCTAssertNotNil(sut.coreDataManager.list.first?.nextPaymentDate)
    }
    
    // MARK: - viewWillDisappear
    func testSortButton_whenViewWillDisappear_sortButtonTitleIsEqual() {
        sut.viewWillDisappear(true)
        
        XCTAssertEqual(sut.sortButton.titleLabel?.text, "정렬방법 ▼")
    }
    
    func testCoreDataManagerList_whenViewWillDisappear_coreDataManagerListDidSort() {
        givenTestServices(repeating: 5)
        
        let sortedList = sut.coreDataManager.list.sorted { $0.createdDate ?? Date() < $1.createdDate ?? Date() }
        
        sut.viewWillDisappear(true)
       
        XCTAssertEqual(sortedList, sut.coreDataManager.list)
    }
    
}
