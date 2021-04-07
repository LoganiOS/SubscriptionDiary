//
//  ShadowView.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit


/**
 BorderView를 상속하는 class입니다. BorderView가 제공하는 속성과 함께 뷰의 Shadow Radius, Shadow Offset, Shadow Color, Shadow Opacity값을 할당하는 기능을 제공합니다.
 
 @IBInspectable 코드로 설정해야 하는 attributes 속성값을 스토리보드에서 할당할 수 있도록 허용합니다.
 
 @IBDesignable 속성은 BorderImageView의 속성이 변경되면 스토리보드에 실시간으로 업데이트 해 주는 기능(live rendering)을 제공합니다.
 */
@IBDesignable class ShadowView: BorderView {

    
    /**
     shadowRadius값을 조절할 수 있습니다. 뷰에서 그림자가 퍼지는 범위가 달라집니다.
     */
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        } set {
            layer.shadowRadius = newValue
        }
    }
    
    
    /**
     shadowOffset값을 조절할 수 있습니다. 그림자의 위치를 조절할 수 있습니다.
     */
    @IBInspectable var shadowOffset : CGSize {
        get {
            return layer.shadowOffset
        } set {
            layer.shadowOffset = newValue
        }
    }

    
    /**
     shadowColor값을 조절할 수 있습니다. 그림자의 색상을 조절할 수 있습니다.
     */
    @IBInspectable var shadowColor : UIColor {
        get {
            guard let shadowColor = layer.shadowColor else { return UIColor() }
            
            return UIColor.init(cgColor: shadowColor)
        } set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    
    /**
     shadowOpacity값을 조절할 수 있습니다. 그림자의 투명도를 조절할 수 있습니다.
     */
    @IBInspectable var shadowOpacity : Float {
        get {
            return layer.shadowOpacity
        } set {
            layer.shadowOpacity = newValue
        }
    }
    
    
}
