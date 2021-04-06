//
//  DateSettingViewControllerDelegate.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit


/**
 StartDateSettingViewController 또는  RenewalDateSettingViewController 에 날짜 속성을 전달하거나 수정할 때 이 프로토콜을 채용해야 합니다.
 
 이 프로토콜을 채택한 ViewController에서 method를 구현할 수 있습니다. 구현한 method는 이 프로토콜이 저장된 객체를 통해 호출할 수 있습니다.
 다른 뷰 컨트롤러에서는 이 프로토콜을 채용하지 않습니다. 다른 뷰 컨트롤러에서 날짜 속성이 필요할 땐 Notification을 사용해야 합니다.
 */
@objc protocol DateSettingViewControllerDelegate {
    
    
    /**
     이 method를 구현하면 startDate값을 전달할 수 있습니다. StartDateSettingViewController에서만 이 *method* 를 호출합니다.
   
     - Parameter viewController: -
     - Parameter startDate: 이 delete를 채용한 ViewController로 startDate값을 전달합니다. (Date? 타입)
     */
    @objc func dateSettingViewController(_ viewController: UIViewController, startDate: Date?)
    
    
    /**
     이 method를 구현하면 renewalDate값을 전달할 수 있습니다. RenewalDateSettingViewController에서만 이 *method* 를 호출합니다.
   
     - Parameter viewController: -
     - Parameter renewalDate: 이 delegate를 채용한 ViewController로 renewalDate값을 전달합니다. (String 타입)
     */
    @objc optional func dateSettingViewController(_ viewController: UIViewController, renewalDate: String)
    
    
    /**
     이 method를 구현하면 alpha값을 전달할 수 있습니다.
   
     - Parameter viewController: -
     - Parameter alpha: 이 delegate를 채용한 ViewController로 alpha값을 전달합니다. (CGFloat 타입)
     */
    @objc optional func dateSettingViewController(_ viewController: UIViewController, alpha: CGFloat)
    
}
