//
//  CornerRadiusView.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit

@IBDesignable class CornerRadiusView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var maxXMinYCorner: Bool {
        get {
            layer.maskedCorners.contains(.layerMaxXMinYCorner)
        } set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }
    
    @IBInspectable var minXMinYCorner: Bool {
        get {
            layer.maskedCorners.contains(.layerMinXMinYCorner)
        } set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }
    
    @IBInspectable var maxXMaxYCorner: Bool {
        get {
            layer.maskedCorners.contains(.layerMaxXMaxYCorner)
        } set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
    
    @IBInspectable var minXMaxYCorner: Bool {
        get {
            layer.maskedCorners.contains(.layerMinXMaxYCorner)
        }  set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }
    
}
