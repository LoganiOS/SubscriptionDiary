//
//  UISegmentedControl.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/24.
//

import UIKit

extension UISegmentedControl {
    func hideBackground() {
        if #available(iOS 13.0, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments-1)  {
                    let backgroundSegmentView = self.subviews[i]
                    backgroundSegmentView.isHidden = true
                }
            }
        }
        
    }
}
