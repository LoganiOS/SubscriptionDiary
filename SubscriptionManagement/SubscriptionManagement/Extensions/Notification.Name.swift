//
//  Notification.Name.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/01.
//

import Foundation

extension Notification.Name {
    static let serviceDidAdd = Notification.Name("serviceDidAdd")
    static let serviceDidDelete = Notification.Name("serviceDidDelete")
    static let serviceDidUpdate = Notification.Name("serviceDidUpdate")
    static let imageDidSelecte = Notification.Name("imageDidSelecte")
    static let startDateDidSelecte = Notification.Name("startDateDidSelecte")
    static let renewalDateDidSelecte = Notification.Name("renewalDateDidSelecte")
}
