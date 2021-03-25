//
//  UIView+shadow.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/11/26.
//

import Foundation
import UIKit

extension UIView {
    
    /// Add Shadow
    /// - Parameters:
    ///   - color: color of shadow. default is 'black'
    ///   - opacity: opacity of shadow. default is 0.15
    ///   - offset: offset of shadow. default is .zero.
    ///   - radius: radius of shadow. default is 7
    func addShadow(color: CGColor = UIColor.black.cgColor, opacity: Float = 0.15, offset: CGSize = .zero, radius: CGFloat = 7) {
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}
