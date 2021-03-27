//
//  DateSettingViewControllerDelegate.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit

@objc protocol DateSettingViewControllerDelegate {
    
    @objc func dateSettingViewController(_ viewController: UIViewController, startDate: Date?)
    @objc optional func dateSettingViewController(_ viewController: UIViewController, renewalDate: String)
    @objc optional func dateSettingViewController(_ viewController: UIViewController, alpha: CGFloat)
    
}
