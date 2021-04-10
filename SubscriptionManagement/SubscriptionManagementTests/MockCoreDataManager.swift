//
//  MockCoreDataManager.swift
//  SubscriptionManagementTests
//
//  Created by LoganBerry on 2021/04/09.
//

import Foundation
import CoreData
@testable import SubscriptionManagement


/**
 CoreDataManager를 대신해 테스트를 진행할 class입니다.
 */
class MockCoreDataManager: CoreDataManager {
    
    
    override func saveContext() {
        
    }
    

    override var mainContext: NSManagedObjectContext {
        return testContainer.viewContext
    }
    
    
    lazy var testContainer: NSPersistentContainer = {
       let desc = NSPersistentStoreDescription()
        desc.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "SavedService")
        container.persistentStoreDescriptions = [desc]
        
        container.loadPersistentStores { (desc, error) in
            if let error = error {
                fatalError(error.localizedDescription)
            }
        }
        
        return container
    }()
    
    
}
