//
//  ServiceListTableViewControllerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/20.
//

import XCTest
@testable import SubscriptionManagement

class ServiceListTableViewControllerTests: XCTestCase {
    
    var nav: UINavigationController!
    var sut: ServiceListTableViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "ServiceListTableViewController") as? ServiceListTableViewController
        
        sut.loadViewIfNeeded()
        nav = UINavigationController(rootViewController: sut)
    }
    
    override func tearDownWithError() throws {
        nav = nil
        sut = nil
    }
    
    // MARK: - viewDidLoad()
    func testSpinner_whenViewDidLoad_spinnerIsNotNil() {
        sut.viewDidLoad()
        
        XCTAssertNotNil(sut.spinner)
    }
    
    func testFilteredServices_whenViewDidLoad_filteredServicesIsEmpty() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.filteredServices.isEmpty)
    }
    
    func testServices_whenViewDidLoad_servicesIsNotEmpty() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.services.isEmpty)
    }
    
    // MARK: - searchController
    func testSearchBarIsEmpty_whenSearchBarTextIsEmpty_returnsTrue() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.searchBarIsEmpty)
    }
    
    func testSearchBarIsEmpty_whenSearchBarTextIsNotEmpty_returnsFalse() {
        sut.viewDidLoad()
        
        sut.searchController.searchBar.text = "test"
        sut.searchController.isActive = true
        XCTAssertFalse(sut.searchBarIsEmpty)
//        XCTAssertTrue(sut.searchController.isActive)
    }
    
    func testFetchSearchController_setSearchController() {
        sut.viewDidLoad()
        
        XCTAssertNotNil(sut.searchController)
        XCTAssertTrue(sut.navigationItem.searchController == sut.searchController)
        XCTAssertTrue(sut.searchController.searchResultsUpdater === sut)
    }
    
    // MARK: - tableView
    
    func testTableView_whenSpinnerIsAnimating_numberOfSectionsAreZero() {
        sut.viewDidLoad()
        
        sut.spinner.startAnimating()
        XCTAssertEqual(sut.tableView.numberOfSections, 0)
    }
    
}
