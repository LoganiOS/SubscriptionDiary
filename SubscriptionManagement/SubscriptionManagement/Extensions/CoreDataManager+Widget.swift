//
//  CoreDataManager.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/11.
//

import CoreData
import UIKit
import WidgetKit


extension CoreDataManager {
    
    
    var url: URL {
        return FileManager.sharedContainer().appendingPathComponent("data.json")
    }
    
    
    func writeSharedJson(list: [SavedServiceEntity]) {
        var services = (1...4).map { (n: Int) -> SavedService in
            SavedService(name: "-", icon: Data(), payment: "-", paymentDate: Date())
        }
        
        let defaultImage = UIImage(named: "DefaultImage")!
        let defaultImageData = defaultImage.pngData() ?? Data()
        
        let didmapList = list.map { service -> SavedService in
            
            let name = service.koreanName ?? "-"
            let pay = service.amountOfPayment ?? "₩ -,---"
            let payDay = service.nextPaymentDate ?? Date()
            
            if let url = service.imageURLString, url.count < 1 {
                return SavedService(name: name, icon: defaultImageData, payment: pay, paymentDate: payDay)
            }
            
            return SavedService(name: name, icon: service.imageURLString?.getImageData() ?? defaultImageData, payment: pay, paymentDate: payDay)
            
        }.sorted(by: { $0.paymentDate < $1.paymentDate })
        
        let values = services.count > didmapList.count ? didmapList.count : services.count
        
        for index in 0..<values {
            services[index] = didmapList[index]
        }
        
        services = services.filter { $0.name != "-" }
        
        do {
            try JSONEncoder().encode(services).write(to: url)
        } catch {
            print(error)
        }
        
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: "SubscriptionWidget")
        }
    }
    
    
    func readSharedJson() -> [SavedService] {
        var list = [SavedService]()
        
        if let data = try? Data(contentsOf: url) {
            do {
                list = try JSONDecoder().decode([SavedService].self, from: data)
            } catch {
                print(error)
            }
        }
        return list
    }
    
    
}
