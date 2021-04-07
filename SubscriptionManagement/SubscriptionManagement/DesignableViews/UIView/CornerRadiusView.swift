//
//  CornerRadiusView.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit


/**
 UIImageView를 상속하는 class입니다. UIView가 제공하는 속성과 함께 뷰의 Corner Radius 값을 변경할 수 있습니다.
 
 @IBInspectable 코드로 설정해야 하는 attributes 속성값을 스토리보드에서 할당할 수 있도록 허용합니다.
 
 @IBDesignable 속성은 BorderImageView의 속성이 변경되면 스토리보드에 실시간으로 업데이트 해 주는 기능(live rendering)을 제공합니다.
 */
@IBDesignable class CornerRadiusView: UIView {
    
    
    /**
     뷰의 전체 cornerRadius값을 지정합니다.
     */
    @IBInspectable var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
        }
    }
    
    
    /**
     뷰 왼쪽 상단 꼭짓점에 Corner Radius를 적용할지 여부를 판단합니다.
     */
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
    
    
    /**
     뷰 왼쪽 하단 꼭짓점에 Corner Radius를 적용할지 여부를 판단합니다.
     */
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
    

    /**
     뷰 오른쪽 상단 꼭짓점에 Corner Radius를 적용할지 여부를 판단합니다.
     */
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
    
    
    /**
     뷰의 오른쪽 하단 꼭짓점에 Corner Radius를 적용할지 여부를 판단합니다.
     */
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
    
    
}
