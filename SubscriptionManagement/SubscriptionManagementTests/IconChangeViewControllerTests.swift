//
//  IconChangeViewControllerTests.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/21.
//

import XCTest
@testable import SubscriptionManagement

class IconChangeViewControllerTests: XCTestCase {
    
    var nav: UINavigationController!
    var sut: IconChangeViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        sut = storyboard.instantiateViewController(withIdentifier: "IconChangeViewController") as? IconChangeViewController
        
        sut.loadViewIfNeeded()
        nav = UINavigationController(rootViewController: sut)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        nav = nil
    }
    
    // MARK:- viewDidLoad
    func testServices_whenViewDidLoad_servicesIsEmpty() {
        sut.viewDidLoad()
        
        XCTAssertTrue(sut.services.isEmpty)
    }
    
    // MARK:- collectionView
    func testCollectionView_numberOfItemsInSectionIsEqualToServicesCount() {
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.iconChangeCollectionView.numberOfItems(inSection: 0), sut.services.count)
    }

    
}
