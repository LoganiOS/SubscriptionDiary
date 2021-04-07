//
//  CoreDataManager.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/01.
//

import Foundation
import CoreData
import UIKit
import WidgetKit


/**
 싱글톤 패턴의 코어데이터 class입니다. shared 속성에 한 번만 메모리를 할당하고 이 메모리에 객체를 만들어 사용합니다.
 */
class CoreDataManager {
    
    
    /**
     ServiceApiManager 타입의 속성입니다.
     */
    static let shared = CoreDataManager()
    
    
    // 다른 코드블럭에서 CoreDataManager 생성을 할 수 없게 생성자에 private Level 키워드를 추가합니다.
    private init() { }
    
    
    /**
     mainContext의 *fetchRequest()* method를 통해 리턴된 배열을 이 속성에 저장합니다.
     */
    var list = [SavedServiceEntity]()
    
    
    var mainContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    
    /**
     사용자가 추가한 서비스 중 다음 결제 예상일이 이번 달에 포함된 서비스만 필터링한 배열입니다.
     */
    var thisMonthServices: [SavedServiceEntity] {
        CoreDataManager.shared.list.filter {
            $0.nextPaymentDate?.month == Date().month &&
            $0.nextPaymentDate?.year == Date().year
        }
    }
    
    
    /**
     사용자가 추가한 서비스의 모든 결제 예상 금액을 합산한 정수 값입니다.
     */
    var total: Int {
        CoreDataManager.shared.list
            .compactMap { $0.amountOfPayment?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
            .compactMap { Int($0) }
            .reduce(0, +)
    }
    
    /**
     사용자가 추가한 서비스 중 다음 결제 예상일이 이번 달에 포함된 서비스만 필터링한 딕셔너리입니다.
     
     키와 값은 아래와 같습니다.
     - key : 카테고리 이름
     - value: 해당 카테고리의 이번달 결제 예상 금액
     */
    var thisMonthServiceCategories: [String: Int] {
        let categories = thisMonthServices.compactMap { $0.category }
        var categoriesTotalValue = [String: Int]()
        
        for category in categories {
            let totalValue = thisMonthServices
                .filter { $0.category == category }
                .compactMap { $0.amountOfPayment?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
                .compactMap { Int($0) }
                .reduce(0, +)
            
            categoriesTotalValue[category] = totalValue
        }
        
        return categoriesTotalValue
    }
    
    
    /**
     카테고리의 결제 예상금액에따라 내림차순으로 정렬한 배열입니다.
     
     배열의 요소는 튜플 형태의 타입입니다.
     */
    var categoryExpenses: Array<(key: String, value: Int)> { thisMonthServiceCategories.sorted { $0.value > $1.value } }
    
    
    /**
     가장 지출이 많은 카테고리의 이름을 배열로 저장합니다. 동일한 값이 존재할 수 있습니다.
     */
    var favoriteCategories: [String] { thisMonthServiceCategories.filter({ $0.value == thisMonthServiceCategories.values.max() }).keys.sorted() }
    
    
    /**
     코어데이터의 mainContext를 통해 요청한 배열을 list 속성에 저장하는 method입니다.
     
     mainContext의 *fetch(_:)* method를 호출하면, 주어진 요청에 따라 기준을 충족하는 배열을 리턴합니다.
     요청이 정상적으로 이루어지면 self.list에 파싱된 데이터를 저장하고 widget에 사용할 *writeSharedJson(list:)* list 파라미터에 이 배열을 전달합니다.
     실패한 경우 error가 출력됩니다.
     */
    func fetch() {
        // request 속성을 저장할 때 NSFetchRequest<EntityType>을 명시적으로 지정해주어야 합니다.
        let request: NSFetchRequest<SavedServiceEntity> = SavedServiceEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdDate", ascending:  true)]
        
        do {
            list = try mainContext.fetch(request)
            CoreDataManager.shared.writeSharedJson(list: list)
        } catch {
            print(error)
        }
    }
    
    
    func add(category: String, name: String, englishName: String, imageURLString: String, payment: String, startDate: Date, renewalDate: String, pushOn notification: Bool) {
        let newService = SavedServiceEntity(context: mainContext)
        newService.createdDate = Date()
        newService.category = category
        newService.koreanName = name
        newService.englishName = englishName
        newService.amountOfPayment = payment
        newService.subscriptionStartDate = startDate
        newService.subscriptionRenewalDate = renewalDate
        newService.nextPaymentDate = startDate.calculatingPaymentDays(renewalDate).first
        newService.notificationIsOn = notification
        newService.imageURLString = imageURLString
        
        list.append(newService)
        saveContext()
    }
    
    
    func update(_ service: SavedServiceEntity, category: String, name: String, englishName: String, imageURLString: String, payment: String, startDate: Date, renewalDate: String, pushOn notification: Bool) {
        service.category = category
        service.koreanName = name
        service.englishName = englishName
        service.amountOfPayment = payment
        service.subscriptionStartDate = startDate
        service.subscriptionRenewalDate = renewalDate
        service.nextPaymentDate = startDate.calculatingPaymentDays(renewalDate).first
        service.notificationIsOn = notification
        service.imageURLString = imageURLString
        
        saveContext()
    }

    
    func delete(_ service: SavedServiceEntity?) {
        guard let service = service else { return }
        mainContext.delete(service)
        
        if let index = list.firstIndex(of: service) {
            list.remove(at: index)
        }
        saveContext()
    }
    
    
    func delete(at index: Int) {
        let target = list[index]
        
        delete(target)
    }
    
     
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SavedService")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
