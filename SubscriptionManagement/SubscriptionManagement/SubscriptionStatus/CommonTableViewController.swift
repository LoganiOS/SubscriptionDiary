//
//  CommonTableViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/04/22.
//

import UIKit

class CommonTableViewController: UITableViewController {

    func identifier(_ matchedID: AccessibilityIdentifier) -> String {
       return matchedID.rawValue
   }

}
