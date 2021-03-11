//
//  FileManager.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/10.
//

import Foundation

extension FileManager {
    static func sharedContainer() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.gookjo.SubscriptionManagement")!
    }
}

