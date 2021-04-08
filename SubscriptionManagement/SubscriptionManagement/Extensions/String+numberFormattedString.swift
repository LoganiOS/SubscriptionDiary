//
//  String.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/06.
//

import Foundation

extension String {
    
    
    /**
     숫자만 포함된 문자열에 이 method를 사용하면 파라미터로 전달된 포멧 문자열로 리턴합니다.
     
     - parameter style: NumberFormatter.Style 타입으로 스타일을 전달할 수 있습니다.
     - Returns: style에서 전달한 Number Formatter가 적용된 String을 리턴합니다. 숫자 이외의 문자가 포함되어 있는 경우 빈 문자열을 리턴합니다.
     */
    func numberFormattedString(_ style: NumberFormatter.Style) -> String {
        let buffer = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let num = Int(buffer) else { return "" }
        
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = style
        numberFormat.locale = Locale(identifier: "ko_kr")

        guard let finalString = numberFormat.string(from: NSNumber(value: num)) else { return "" }
        
        return finalString
    }
    
    
}
