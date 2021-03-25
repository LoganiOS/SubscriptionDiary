





import Foundation
import CoreData
import UIKit
import WidgetKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    /// 유저가 저장한 서비스 목록
    var list = [SavedServiceEntity]()
    
    var mainContext: NSManagedObjectContext { return persistentContainer.viewContext }
    
    /// 이번달의 결제 예정 서비스
    var thisMonthServices: [SavedServiceEntity] {
        CoreDataManager.shared.list.filter {
            $0.nextPaymentDate?.month == Date().month &&
            $0.nextPaymentDate?.year == Date().year
        }
    }
    
    var total: Int {
        CoreDataManager.shared.list
            .compactMap { $0.amountOfPayment?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }
            .compactMap { Int($0) }
            .reduce(0, +)
    }
    
    /// 이번달의 결제 예정 서비스의 카테고리
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
    
    /// 지출에 따른 카테고리 정렬
    var categoryExpenses: Array<(key: String, value: Int)> { thisMonthServiceCategories.sorted { $0.value > $1.value } }
    
    /// 가장 지출이 많은 카테고리 (동일한 값 허용)
    var favoriteCategories: [String] { thisMonthServiceCategories.filter({ $0.value == thisMonthServiceCategories.values.max() }).keys.sorted() }
    
    func fetch() {
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


