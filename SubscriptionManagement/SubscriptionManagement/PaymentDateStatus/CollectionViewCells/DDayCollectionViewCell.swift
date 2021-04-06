//
//  DDayCollectionViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/16.
//

import UIKit


/**
 이 Cell은 dDayCollectionView의 재사용 Cell로 사용됩니다. 사용자가 추가한 서비스의 D-Day를 표시합니다.
 */
class DDayCollectionViewCell: UICollectionViewCell {
    
    
    /**
     사용자가 추가한 서비스의 이미지를 표시하는 UIImageView입니다.
     */
    @IBOutlet weak var serviceImageView: BorderImageView!
    
    
    /**
     사용자가 추가한 서비스 명을 표시하는 UILabel입니다.
     */
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    
    /**
     사용자가 추가한 서비스의 다가오는 결제일을 D-Day 형태로 표시하는 UILabel입니다.
     */
    @IBOutlet weak var dDayCountLabel: UILabel!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     collectionView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier = "DDayCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = false
        
    }
    
    
}
