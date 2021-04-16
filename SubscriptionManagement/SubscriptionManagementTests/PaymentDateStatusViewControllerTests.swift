//
//  PaymentDateStatusViewControllerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/16.
//

import XCTest
@testable import SubscriptionManagement

class PaymentDateStatusViewControllerTests: XCTestCase {
    
    var nav: UINavigationController!
    var tab: UITabBarController!
    var sut: PaymentDateStatusViewController!
    
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
        
        sut = storyboard.instantiateViewController(withIdentifier: "PaymentDateStatusViewController") as? PaymentDateStatusViewController
        
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

    
    // MARK: - viewDidLoad()
    func testServiceNextPaymentDates_whenCoreDataIsEmpty_serviceNextPaymentDatesAreEmpty() {
        XCTAssertTrue(sut.serviceNextPaymentDates.isEmpty)
    }
    
    func testServiceNextPaymentDates_whenCoreDataIsNotEmpty_serviceNextPaymentDatesAreNotEmpty() {
        givenTestServices(repeating: 5)
        sut.viewDidLoad()
        
        XCTAssertTrue(!sut.serviceNextPaymentDates.isEmpty)
    }
    
    func testSavedServicesSortedByDate_whenCoreDataIsEmpty_equalSortedCoreDataListByDate() {
        givenTestServices(repeating: 5)
        sut.viewDidLoad()
        
        let expectedArray = sut.coreDataManager.list.sorted { $0.nextPaymentDate ?? Date() < $1.nextPaymentDate ?? Date() }
        
        XCTAssertEqual(expectedArray, sut.savedServicesSortedByDate)
    }
    
    func testThisMonthServiceCategoriesTotalPayment_whenCoreDataIsEmpty_thisMonthServiceCategoriesValueIsZero() {
        sut.viewDidLoad()
        
        XCTAssertEqual(0, sut.thisMonthServiceCategoriesTotalPayment)
    }
    
    // MARK: - viewWillAppear(_:)
    func testCoreDataManager_whenViewWillAppear_coreDataManagerListIsEmpty() {
        sut.viewWillAppear(true)
        
        XCTAssertTrue(sut.coreDataManager.list.isEmpty)
    }
    
    func testCoreDataManager_whenViewWillAppearAndCoreDataManagerListExists_calculatePaymentDays() {
        givenTestServices(repeating: 5)
        sut.viewWillAppear(true)
        
        let givenService = sut.coreDataManager.list.first!
        
        let nextPayDate = givenService.nextPaymentDate
        let calculatedNextPayDate = givenService.subscriptionStartDate?.calculatingPaymentDays(givenService.subscriptionRenewalDate ?? "1개월").first!
        
        XCTAssertEqual(nextPayDate, calculatedNextPayDate)
    }
    
    // MARK: - viewDidDisappear(_:)
    func testSavedServicesSortedBySelectedDate_whenViewDidDisappear_savedServicesSortedBySelectedDateIsEmpty() {
        sut.viewDidDisappear(true)
        
        XCTAssertTrue(sut.savedServicesSortedBySelectedDate.isEmpty)
    }
    
    func testSelectedDate_whenViewDidDisappear_selectedDateIsNil() {
        sut.viewDidDisappear(true)
        
        XCTAssertNil(sut.selectedDate)
    }
    
    func testDidEndScroll_whenViewDidDisappear_didEndScrollIsFalse() {
        sut.viewDidDisappear(true)
        
        XCTAssertFalse(sut.didEndScroll)
    }
    
    // MARK:- scrollViewDidScroll
    func testScrollViewDidScroll_whenFavoriteCategoryTableViewContentOffsetIsLessThen40_didEndScrollIsFalse() {
        sut.favoriteCategoryTableView.contentOffset.y = 40
        sut.scrollViewDidScroll(sut.favoriteCategoryTableView)
        
        XCTAssertFalse(sut.didEndScroll)
    }
    
    func testScrollViewDidScroll_whenFavoriteCategoryTableViewContentOffsetIsGreaterThen40_didEndScrollIsTrue() {
        sut.favoriteCategoryTableView.contentOffset.y = 41
        sut.scrollViewDidScroll(sut.favoriteCategoryTableView)
        
        XCTAssertTrue(sut.didEndScroll)
    }
    

}
