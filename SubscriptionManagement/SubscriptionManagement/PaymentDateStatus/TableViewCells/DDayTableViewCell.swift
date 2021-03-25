//
//  DDayTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/18.
//

import UIKit

class DDayTableViewCell: UITableViewCell {
   
    @IBOutlet weak var dDayCollectionView: UICollectionView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        dDayCollectionView.reloadData()
    }
    
}
