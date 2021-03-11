//
//  String+Attribute.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/20.
//

import UIKit

extension String {
    func addingBoldAttribute(fontSize: CGFloat = 17, boldRange: String) -> NSMutableAttributedString {
        let fontSize = UIFont.boldSystemFont(ofSize: fontSize)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key(rawValue: kCTFontAttributeName as String), value: fontSize, range: (self as NSString).range(of: boldRange))

        return attributedString
    }
}
