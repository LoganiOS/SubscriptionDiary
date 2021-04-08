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
    
    
    /**
     사용자가 추가한 서비스의 결제 예상일 하루 전 Push 알람을 보내줍니다.
     
     이 method는 사용자가 서비스를 추가하거나 수정할 때 서비스의 notificationIsOn 속성이 true인 경우에만 호출해야합니다.
     
     - parameter service: push 알람을 보낼 SavedServiceEntity 속성을 전달합니다.
     */
    public func addLocalNotification(service: SavedServiceEntity) {
        guard service.notificationIsOn else { return }
        guard let name = service.koreanName else { return }
        guard let startDate = service.subscriptionStartDate else { return }
        guard let renewalDate = service.subscriptionRenewalDate else { return }
        
        let content = UNMutableNotificationContent()
        
        content.title = "결제일 D-1"
        content.body = "내일은 '\(name)'서비스의 결제 예상일입니다."
        
        var unit = 0
        
        /*
         Local Notification은 앱 당 최대 64개까지만 푸시 알람을 예약할 수 있습니다.
         *calculatingPaymentDays(_:)* method를 통해 가져온 결제 예상일 [Date] 배열에서 다가오는 결제일이 빠른 순서대로
         서비스 당 최대 4개까지만 예약합니다.
         */
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
    
    
    /**
     사용자가 AddServiceTableViewController에서 결제일 하루 전 알림을 원하지 않거나 서비스를 삭제한 경우 이 method를 호출해야합니다.
     
     삭제를 위해 identifiers를 전달해야 합니다. identifiers는 추가했던 서비스의 이름입니다.
     
     - parameter service: 서비스의 이름을 문자열로 전달합니다.
     */
    public func removeLocalNotification(with name: String)  {
        let identifiers = ["\(name)0", "\(name)1", "\(name)2", "\(name)3"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
}
