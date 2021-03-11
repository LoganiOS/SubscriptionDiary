
import Foundation

extension String {
    func numberFormattedString(_ style: NumberFormatter.Style) -> String {
        let buffer = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let num = Int(buffer) else { return "" } // fatal error로 바꾸기
        
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = style
        numberFormat.locale = Locale(identifier: "ko_kr")

        guard let finalString = numberFormat.string(from: NSNumber(value: num)) else { return "" }
        return finalString
    }
}
