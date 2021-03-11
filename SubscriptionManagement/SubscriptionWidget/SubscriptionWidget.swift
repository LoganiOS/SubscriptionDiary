//
//  SubscriptionWidget.swift
//  SubscriptionWidget
//
//  Created by LoganBerry on 2021/02/11.
//

import WidgetKit
import UIKit
import SwiftUI
import CoreData

@main
struct SubscriptionWidget: Widget {
    let kind: String = "SubscriptionWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SubscriptionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("구독이")
        .description("구독서비스 정리")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
