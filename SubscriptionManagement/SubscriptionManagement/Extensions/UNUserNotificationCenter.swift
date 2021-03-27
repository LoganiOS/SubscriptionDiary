//
//  UNUserNotificationCenter.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/06.
//

import Foundation
import NotificationCenter
import UserNotifications

extension UNUserNotificationCenter {
    
    public func addLocalNotification(service: SavedServiceEntity) {
        guard service.notificationIsOn else { return }
        guard let name = service.koreanName else { return }
        guard let startDate = service.subscriptionStartDate else { return }
        guard let renewalDate = service.subscriptionRenewalDate else { return }
        let content = UNMutableNotificationContent()
        content.title = "결제일 D-1"
        content.body = "내일은 '\(name)'서비스의 결제 예상일입니다."
        
        var unit = 0
        for date in startDate.calculatingPaymentDays(renewalDate) {
            if unit == 4 { return }
            content.categoryIdentifier = "\(name)\(unit)"
            let matchedDate = DateComponents(year: date.year, month: date.month, day: date.day, hour: 14)
            let trigger = UNCalendarNotificationTrigger(dateMatching: matchedDate, repeats: false)
            let request = UNNotificationRequest(identifier: content.categoryIdentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { _ in }
            unit += 1
        }
    }

    public func removeLocalNotification(with name: String)  {
        let identifiers = ["\(name)0", "\(name)1", "\(name)2", "\(name)3"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }

}
