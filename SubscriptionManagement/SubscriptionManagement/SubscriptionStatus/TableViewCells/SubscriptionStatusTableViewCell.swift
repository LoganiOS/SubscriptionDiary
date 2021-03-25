//
//  SubscriptionStatusTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit

class SubscriptionStatusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: BorderImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    
    static let identifier: String = "SubscriptionStatusTableViewCell"
    
}
