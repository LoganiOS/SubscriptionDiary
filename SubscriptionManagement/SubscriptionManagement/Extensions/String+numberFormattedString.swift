//
//  String.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/06.
//

import Foundation

extension String {
    
    /// 문자열을 정수형으로 변환한 다음, 파라미터로 전달된 포멧 문자열로 리턴합니다.
    /// - Parameter style: Number Formatter 스타일을 지정합니다.
    /// - Returns: 문자열을 리턴합니다.
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
