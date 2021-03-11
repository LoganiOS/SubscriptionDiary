//
//  SubscriptionProvider.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/11.
//

import Foundation
import WidgetKit

let snapshotData = SubscriptionEntry(date: Date(), list: SavedService.dummy)

struct Provider: TimelineProvider {
    typealias Entry = SubscriptionEntry
    func placeholder(in context: Context) -> SubscriptionEntry {
        snapshotData
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SubscriptionEntry) -> ()) {
        completion(snapshotData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SubscriptionEntry>) -> ()) {
        let entries: [SubscriptionEntry] = [SubscriptionEntry(date: Date(), list: CoreDataManager.shared.readSharedJson())]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        
        completion(timeline)
    }
}
