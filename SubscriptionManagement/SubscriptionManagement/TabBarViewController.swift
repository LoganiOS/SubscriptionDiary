//
//  TabBarViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/11/15.
//

import UIKit
import AudioToolbox

class TabBarViewController: UITabBarController {

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
         
        // MARK:- weak vibration
        //UIDevice.current.batteryLevel로 배터리 상태를 체크한 다음 사용
        // AudioServicesPlaySystemSound(1519)
        
    }

}
