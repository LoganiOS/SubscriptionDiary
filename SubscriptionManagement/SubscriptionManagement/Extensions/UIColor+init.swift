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
    
    /**
     Hex Color Code로 UIColor를 생성합니다.
     
     빨강색, 녹색, 파랑색을 0부터 255까지 표현한 RGB 색상을 16진수로 표현한 Hex Color Code로 생성하는 생성자입니다.
     
     - parameter hex: Hex Color Code를 전달합니다.
     */
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF)
    }
    
    
}
