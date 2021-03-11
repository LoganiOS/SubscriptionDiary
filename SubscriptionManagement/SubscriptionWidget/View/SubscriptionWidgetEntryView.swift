//
//  SubscriptionWidgetEntryView.swift
//  SubscriptionWidgetExtension
//
//  Created by LoganBerry on 2021/02/14.
//

import Foundation
import SwiftUI
import WidgetKit

struct SubscriptionWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family
//    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            GeometryReader {
                reader in
//                Color(.systemBackground)
            }
            
            switch family {
            case .systemSmall:
                SavedServiceView(entry: entry)

            case .systemMedium:
                SavedServiceView(entry: entry)
                
            default :
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.black))
    }
    
    struct SubscriptionWidget_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                SubscriptionWidgetEntryView(entry: snapshotData)
                    .previewContext(WidgetPreviewContext(family: .systemMedium))
            }
            
        }
    }
}

