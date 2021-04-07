//
//  URL+.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/13.
//

import Foundation

extension URL {
    
    /**
     URL 속성을 백업 대상에서 제외할 때 이 method를 호출합니다.
     */
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
