//
//  CommonViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/04/22.
//

import UIKit

class CommonViewController: UIViewController {
    
     func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }

}
