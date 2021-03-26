//
//  ColorCollectionViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/01/05.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImageView: BorderImageView!
    @IBOutlet weak var checkImageView: UIImageView! 
    @IBOutlet weak var themeLabel: UILabel!
    
    static let identifier = "ColorCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkImageView.isHidden = true
    }
    
}
