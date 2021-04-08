//
//  Date+dateString.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/17.
//

import UIKit

extension Date {
    
    
    // Date 타입의 년, 월, 일이 같다면 true를 리턴합니다.
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    
    /**
     '일'에 해당하는 Int 속성입니다.
     */
    var day: Int {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_kr")
        
        return cal.component(.day, from: self)
    }
    
    
    /**
     '월'에 해당하는 Int 속성입니다.
     */
    var month: Int {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_kr")
        
        return cal.component(.month, from: self)
    }
    
    
    /**
     '년도'에 해당하는 Int 속성입니다.
     */
    var year: Int {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ko_kr")
        
        return cal.component(.year, from: self)
    }
    
    
    /**
     주어진 날짜를 포멧된 문자열로 리턴합니다.
     
     자세한 속성은 아래와 같습니다.
     - locale: "ko_kr"
     - dateStyle = .short
     - timeStyle = .none
     - doesRelativeDateFormatting = true
     
     - returns : 문자열을 리턴합니다.
     */
    func formattedString() -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "ko_kr")
        dateFormat.dateStyle = .short
        dateFormat.timeStyle = .none
        dateFormat.doesRelativeDateFormatting = true
        
        return dateFormat.string(from: self)
    }
    
    
    /**
     연, 월, 일만 입력받아 인스턴스를 생성할 수 있습니다. Optional입니다.
     
     - parameter year: 년도에 해당하는 Int타입 속성을 전달할 수 있습니다.
     - parameter month: 월에 해당하는 Int타입 속성을 전달할 수 있습니다.
     - parameter day: 일에 해당하는 Int타입 속성을 전달할 수 있습니다.
     */
    init?(year: Int, month: Int, day: Int) {
        let dateComponents = DateComponents(year: year, month: month, day: day)
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        guard let date = calendar.date(from: dateComponents) else { return nil }
        
        self = date
    }
 
    
}



//
extension Date {
    
    
    /**
     - Parameter renewalDateString:
     - Returns:
     */
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
