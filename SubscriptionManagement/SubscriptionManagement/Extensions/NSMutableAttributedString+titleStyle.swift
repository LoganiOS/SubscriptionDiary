

import Foundation
import UIKit

extension NSMutableAttributedString {
    static func attributedFont(_ string: String, weight: UIFont.Weight, size: CGFloat = 28) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: size, weight: weight)]
        return NSMutableAttributedString(string: string, attributes: attributes)
    }
}
