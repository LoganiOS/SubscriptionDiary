//
//  IconChangeCollectionViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit


/**
 이 Cell을 통해 서비스 로고를 IconChangeViewController 뷰 컨트롤러에 표시할 수 있습니다.
 
 이 Cell은 iconChangeCollectionView의 재사용 Cell로 사용됩니다.
 */
class IconChangeCollectionViewCell: UICollectionViewCell {
    
    
    /**
     서비스 로고를 표시할 BorderImageView입니다.
     */
    @IBOutlet weak var iconImageView: BorderImageView!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     collectionView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier에 이 속성을 전달하세요.
     */
    static let identifier = "IconChangeCollectionViewCell"
    
    
}
