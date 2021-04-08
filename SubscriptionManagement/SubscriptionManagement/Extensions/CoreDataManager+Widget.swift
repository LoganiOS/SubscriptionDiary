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
        
        let didmapList = list.map { SavedService(name: $0.koreanName ?? "-",
                                                 icon: $0.imageURLString?.getImageData() ?? Data(),
                                                 payment: $0.amountOfPayment ?? "-",
                                                 paymentDate: $0.nextPaymentDate ?? Date()) }
        
        let values = services.count > didmapList.count ? didmapList.count : services.count
        for index in 0..<values { services[index] = didmapList[index] }
        
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
