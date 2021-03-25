//
//  ServiceListTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit

class ServiceListTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var plusImageView: UIImageView!
    
    static let identifier: String = "ServiceListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(rgb: CustomColor.shared.themes[index].main)
        plusImageView.tintColor = customTintColor
    }

}
