//
//  UIColor.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/16.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

    
    /// initialize with Hex Color code
    /// - Parameter rgb: example) white = 0xFFFFFF
   convenience init(rgb: Int) {
    
       self.init(
           red: (rgb >> 16) & 0xFF, // RGB에 있는 비트를 16번 오른쪽으로 이동시키고,  0xFF를 2진수로 변환 한다음 & 연산자로 비교 // 이거 내용 봐야함
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
