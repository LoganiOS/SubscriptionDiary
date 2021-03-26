//
//  SavedService.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/12.
//

import UIKit
import WidgetKit

public struct SavedService: Codable {
    
    let name: String
    let icon: Data
    let payment: String
    let paymentDate: Date
    
    static var dummy: [SavedService] {
        return (0...3).map { _ in
            SavedService(name: "-", icon: Data(), payment: "-", paymentDate: Date())
        }
    }
    
}

