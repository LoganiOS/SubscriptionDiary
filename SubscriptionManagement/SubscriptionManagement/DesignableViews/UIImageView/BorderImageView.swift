//
//  BorderImageView.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit


/**
 CornerRadiusImageView를 상속하는 class입니다. CornerRadiusImageView가 제공하는 속성과 함께 뷰의 테두리 굵기와 색상을 변경하는 기능을 제공합니다.
 
 @IBInspectable 코드로 설정해야 하는 attributes 속성값을 스토리보드에서 할당할 수 있도록 허용합니다.
 
 @IBDesignable 속성은 BorderImageView의 속성이 변경되면 스토리보드에 실시간으로 업데이트 해 주는 기능(live rendering)을 제공합니다.
 */
@IBDesignable class BorderImageView: CornerRadiusImageView {

    
    /**
     UIView의 테두리 색상을 지정합니다. 기본값은 .clear입니다.
     */
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    
    /**
     UIView의 테두리 굵기를 지정합니다. 기본값은 0입니다.
     */
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    
}
