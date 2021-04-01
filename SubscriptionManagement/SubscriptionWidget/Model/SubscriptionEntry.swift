//
//  SubscriptionEntry.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/11.
//

import Foundation
import WidgetKit
import CoreData

struct SubscriptionEntry: TimelineEntry {
    
    let date: Date
    let list: [SavedService]
    
}
