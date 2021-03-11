//
//  Date+dateString.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/17.
//

import UIKit

extension Date {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    var day: Int {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_kr")
        return cal.component(.day, from: self)
    }
    var month: Int {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_kr")
        return cal.component(.month, from: self)
    }
    var year: Int {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_kr")
        return cal.component(.year, from: self)
    }
    
    func formattedString(after component: Calendar.Component = .month, value: Int = 0) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        guard let renewalDate = calendar.date(byAdding: component, value: value, to: self) else { return "" }
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_kr")
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        dateFormat.doesRelativeDateFormatting = true 
        return dateFormat.string(from: renewalDate)
    }
    
    init?(year: Int, month: Int, day: Int) {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        guard let date = calendar.date(from: dateComponents) else { return nil }
        self = date
    }
}

extension Date {
    
    /// Return PaymentDays in Date Array
    /// - Parameter renewalDateString: 
    /// - Returns: [Date]
    func calculatingPaymentDays(_ renewalDateString: String) -> [Date] {
        var component: Calendar.Component = .month
        
        switch renewalDateString {
        case let date where date.contains("주"):
            component = .weekOfMonth
        case let date where date.contains("개월"):
            component = .month
        case let date where date.contains("년"):
            component = .year
        default:
            break
        }
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        var paymentDays = [Date]()
        let value = Int(renewalDateString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
        let paymentDayValues = [Int](stride(from: value, to: 1000, by: value))
        for dayValue in paymentDayValues {
            guard let date = calendar.date(byAdding: component, value: dayValue, to: self) else { return [Date]() }
            paymentDays.append(date)
        }
        return paymentDays.filter { Date() <= $0 }
    }
}
