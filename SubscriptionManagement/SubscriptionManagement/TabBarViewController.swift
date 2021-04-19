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
         AudioServicesPlaySystemSound(1519)
    
    }

}
