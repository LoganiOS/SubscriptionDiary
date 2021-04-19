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
    
    // MARK: - viewDidAppear(_:)
    func testCalendarView_whenViewDidAppear_calendarViewExists() {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        sut.viewDidAppear(true)
        
        XCTAssertTrue(sut.favoriteCategoryTableView.cellForRow(at: IndexPath(row: 0, section: 0)) is CalendarTableViewCell)
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
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        
        sut.favoriteCategoryTableView.contentOffset.y = 41
        sut.scrollViewDidScroll(sut.favoriteCategoryTableView)
        
        XCTAssertTrue(sut.didEndScroll)
    }
    
    // MARK:- tableView
    private func given_tableViewCellForRow(at row: Int) -> UITableViewCell {
        return sut.favoriteCategoryTableView.cellForRow(at: IndexPath(row: row, section: 0))!
    }
    
    
    func testTableView_whenDequeueAndIndexPathRowIsZero_CellTypeIsMatched() {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        
        let cell = given_tableViewCellForRow(at: 0)
        
        XCTAssertTrue(cell is CalendarTableViewCell)
    }
    
    func testTableView_whenDequeueAndIndexPathRowIsOneAndCoreDataManagerIsNotEmpty_CellTypeIsMatched() {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        
        givenTestServices(repeating: 5)
        
        let cell = given_tableViewCellForRow(at: 1)
        XCTAssertTrue(cell is DDayTableViewCell)
    }
    
    func testTableView_whenDequeueAndIndexPathRowIsTwo_CellTypeIsMatched() {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        
        let cell = given_tableViewCellForRow(at: 2)
        XCTAssertTrue(cell is FavoriteCategoryTableViewCell)
    }
    
    // MARK:- collectionView
    func testCollectionView_whenSavedServicesSortedBySelectedDateIsEmpty_numberOfItemsIsEqualCoreDataManagerListCount() {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        
        givenTestServices(repeating: 5)
        let cell = given_tableViewCellForRow(at: 1) as! DDayTableViewCell
        
        XCTAssertEqual(cell.dDayCollectionView.numberOfItems(inSection: 0), sut.coreDataManager.list.count)
    }
    
    func testCollectionView_whenSavedServicesSortedBySelectedDateIsNotEmpty_numberOfItemsIsEqualSavedServicesSortedBySelectedDateCount() {
        sut.viewDidLoad()
        sut.viewWillAppear(true)
        
        givenTestServices(repeating: 5)
        sut.savedServicesSortedBySelectedDate = sut.coreDataManager.list.dropLast()
        
        let cell = given_tableViewCellForRow(at: 1) as! DDayTableViewCell
        
        XCTAssertEqual(cell.dDayCollectionView.numberOfItems(inSection: 0), sut.savedServicesSortedBySelectedDate.count)
    }

    
}
