//
//  SettingViewControllerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/21.
//

import XCTest
@testable import SubscriptionManagement

class SettingViewControllerTests: XCTestCase {
    
    var nav: UINavigationController!
    var tab: UITabBarController!
    var sut: SettingViewController!

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "SettingViewController") as? SettingViewController
        
        sut.loadViewIfNeeded()
        nav = UINavigationController(rootViewController: sut)
        
        tab = UITabBarController()
        tab.addChild(nav)
    }

    override func tearDownWithError() throws {
        nav = nil
        sut = nil
        tab = nil
    }

    // MARK:- viewWillAppear(_:)
    func testNavigationBar_whenViewWillAppear_navigationBarIsHidden() {
        sut.viewWillAppear(true)
        
        XCTAssertTrue(sut.navigationController!.navigationBar.isHidden)
    }
    
    // MARK:- viewWillDisappear(_:)
    func testNavigationBar_whenViewWillDisappear_navigationBarIsNotHidden() {
        sut.viewWillDisappear(true)
        
        XCTAssertFalse(sut.navigationController!.navigationBar.isHidden)
    }

    // MARK:- tableView
    func testListTableView_whenInit_didAdoptDelegate() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.listTableView.delegate === sut)
        XCTAssertTrue(sut.listTableView.dataSource === sut)
    }

}
