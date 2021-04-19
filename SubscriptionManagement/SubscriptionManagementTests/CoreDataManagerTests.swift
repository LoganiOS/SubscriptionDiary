//
//  CoreDataManagerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/09.
//

import XCTest
@testable import SubscriptionManagement

/**
 CoreDataManager를 테스트하기 위한 class입니다.
 */
class CoreDataManagerTests: XCTestCase {
    
    
    /**
     System under tests: 테스트를 하려는 대상을 속성으로 저장합니다.
     */
    var sut: CoreDataManager!
    
    private let categories = ["OTT", "음악", "사무", "기타"]
    private let names = [("넷플릭스", "netflix"), ("유튜브 프리미엄", "youtube premium"), ("플로", "flo"), ("어도비 XD","adobe XD")]
    private let renewalDates = ["1주", "2주", "1개월", "2개월"]
    
    private func givenTestServices(repeating count: Int) {
        for _ in 1...count {
            let n = Int.random(in: 0...3)
            
            sut.add(category: categories[n],
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
        sut = MockCoreDataManager()
    }
    
    override func tearDownWithError() throws {
        sut.mainContext.rollback()
        sut.mainContext.reset()
        
        sut = nil
    }
    
    
    // MARK: - init
    func testList_whenInit_listsAreEmpty() {
        XCTAssertTrue(sut.list.isEmpty)
    }
    
    func testTotal_whenInit_totalValueIsZero() {
        XCTAssertEqual(sut.total, 0)
    }
    
    func testMainContext_whenInit_mainContextIsNotNil() {
        XCTAssertNotNil(sut.mainContext)
    }
    
    func testThisMonthServices_whenInit_thisMonthServicesIsEmpty() {
        XCTAssertTrue(sut.thisMonthServices.isEmpty)
    }
    
    func testThisMonthServiceCategories_whenInit_thisMonthServiceCategoriesIsEmpty() {
        XCTAssertTrue(sut.thisMonthServiceCategories.isEmpty)
    }
    
    func testCategoryExpenses_whenInit_categoryExpensesIsEmpty() {
        XCTAssertTrue(sut.categoryExpenses.isEmpty)
    }
    
    
    // MARK: - CoreDataManager when called add method
    func testList_whenAdd_appendedToList() {
        // given
        let beforeCount = sut.list.count
        
        // when
        sut.add(category: "OTT", name: "넷플릭스", englishName: "netflix", imageURLString: "", payment: "12900", startDate: Date(), renewalDate: "1개월", pushOn: true)
        
        // then
        let afterCount = sut.list.count
        XCTAssertEqual(beforeCount + 1, afterCount)
    }
    
    func testList_whenAdd_appendedToLast() {
        // given + when
        let n = 3
        givenTestServices(repeating: n)
        
        // then
        XCTAssertEqual(sut.list.last, sut.list[n-1])
    }
    
    func testTotal_whenAdd_totalValueIsReduced() {
        // given + when
        givenTestServices(repeating: 5)
        
        let expectedValue = sut.list
            .compactMap { $0.amountOfPayment }
            .compactMap { Int($0) }
            .reduce(0, +)
        
        // then
        XCTAssertEqual(sut.total, expectedValue)
    }
    
    func testThisMonthServices_whenAdd_thisMonthServicesAreFiltered() {
        // given + when
        givenTestServices(repeating: 5)
        
        let expectedValue = sut.list.filter {
                $0.nextPaymentDate?.month == Date().month &&
                    $0.nextPaymentDate?.year == Date().year
        }.count
        
        // then
        XCTAssertEqual(sut.thisMonthServices.count, expectedValue)
    }
    
    func testThisMonthServiceCategories_whenAdd_thisMonthServiceCategoriesAreMapped() {
        // given + when
        let key = categories[Int.random(in: 0..<categories.count)]
        
        givenTestServices(repeating: 10)
        
        let expectedCateogries = Array(Set(sut.thisMonthServices.compactMap { $0.category })).sorted()
        
        var expectedTotalAssociatedWithCategory = [String:Int]()
        
        for category in expectedCateogries {
            let totalValue = sut.thisMonthServices
                .filter { $0.category == category }
                .compactMap { $0.amountOfPayment?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
                .compactMap { Int($0) }
                .reduce(0, +)
            
            expectedTotalAssociatedWithCategory[category] = totalValue
        }
        
        // then
       
        // Dictionary's key test
        XCTAssertEqual(expectedCateogries, sut.thisMonthServiceCategories.keys.sorted())
      
        // Dictionary's value test
        XCTAssertEqual(expectedTotalAssociatedWithCategory[key], sut.thisMonthServiceCategories[key])
    }
    
    func testCategoryExpenses_whenAdd_categoryExpensesAreSorted() {
        // given
        givenTestServices(repeating: 10)
        
        let sortedCategoriesAndTotal: Array<(key: String, value: Int)> = sut.thisMonthServiceCategories.sorted { $0.value > $1.value }
        
        let expectedCategories = sortedCategoriesAndTotal.map { $0.key }
        
        let expectedTotalValue = sortedCategoriesAndTotal.map { $0.value }
        
        // then
        
        // Dictionary's key test
        XCTAssertEqual(expectedCategories, sut.categoryExpenses.map { $0.key })
        
        // Dictionary's value test
        XCTAssertEqual(expectedTotalValue, sut.categoryExpenses.map { $0.value })
    }
    
    func testFavoriteCategories_whenAdd_favoriteCategoriesAreEqual() {
        // given
        givenTestServices(repeating: 10)
        let expectedCategories = sut.thisMonthServiceCategories
            .filter({ $0.value == sut.thisMonthServiceCategories.values.max() })
            .keys
            .sorted()
        
        XCTAssertEqual(expectedCategories, sut.favoriteCategories)
    }
    
    
    // MARK: - CoreDataManager when called update method
    func testServiceis_whenUpdate_serviceisUpdated() {
        // given
        let service = SavedServiceEntity(context: sut.mainContext)
        service.koreanName = "넷플릭스"
        
        // when
        let i = Int.random(in: 0...3)
        
        let expectedCategory = categories[i]
        let expectedName = names[i]
        let expectedPayment = "\(i)"
        let expectedRenewalDate = renewalDates[i]
        
        sut.update(service, category: expectedCategory, name: expectedName.0, englishName: expectedName.1, imageURLString: "", payment: expectedPayment, startDate: Date(), renewalDate: expectedRenewalDate, pushOn: true)
        
        // then
        XCTAssertEqual(service.category, expectedCategory)
        XCTAssertEqual(service.koreanName, expectedName.0)
        XCTAssertEqual(service.amountOfPayment, expectedPayment)
        XCTAssertEqual(service.subscriptionRenewalDate, expectedRenewalDate)
    }
    
    // MARK: - CoreDataManager when called delete method
    func testDelete_whenDeleteTargetIsNil_returnsFalse() {
        XCTAssertFalse(sut.delete(nil))
    }
    
    func testDelete_whenDeleteTargetIsNotNil_returnsTrue() {
        // given
        givenTestServices(repeating: 5)
        
        let service = sut.list.last
        let beforeCount = sut.list.count
        
        XCTAssertNotNil(service)
        
        // when
        let returnValue = sut.delete(service)
        let afterCount = sut.list.count
        
        // then
        XCTAssertTrue(returnValue)
        XCTAssertFalse(sut.list.contains(service!))
        XCTAssertEqual(beforeCount, afterCount + 1)
    }
    
    func testDataManager_whenDeleteIndexIsInvalid_returnsNil() {
        XCTAssertNil(sut.delete(at: 1))
    }
    
    func testDelete_whenDeleteIndexIsValid_returnsNotNil() {
        // given
        let count = 10
        let index = count - 1
        givenTestServices(repeating: count)
        
        // when + then
        XCTAssertNotNil(sut.delete(at: index))
    }
    
    func testDelete_whenDeleteIndexIsValid_deletedServiceIsEqual() {
        // given
        let count  = 10
        let index = count - 1
        
        givenTestServices(repeating: count)
        
        let expectedService = sut.list[index]
        
        // when
        XCTAssertEqual(sut.delete(at: index), expectedService)
    }
    
}
