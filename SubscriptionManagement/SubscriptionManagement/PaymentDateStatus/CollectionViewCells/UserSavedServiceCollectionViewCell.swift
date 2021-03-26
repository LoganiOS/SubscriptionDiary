//
//  DDayCollectionViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/16.
//

import UIKit

class DDayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImageView: BorderImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var dDayCountLabel: UILabel!
    
    static let identifier = "DDayCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
    }
    
}
