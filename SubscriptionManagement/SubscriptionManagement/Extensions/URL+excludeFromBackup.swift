//
//  URL+.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/13.
//

import Foundation

extension URL {
    
    /// Exclude cache data from backup
    mutating func excludeFromBackup() {
        do {
            let exist = try checkResourceIsReachable()
            if exist {
                var resourceValues = URLResourceValues()
                resourceValues.isExcludedFromBackup = true
                try setResourceValues(resourceValues)
            }
        } catch {
            print(error)
        }
    }
    
}
