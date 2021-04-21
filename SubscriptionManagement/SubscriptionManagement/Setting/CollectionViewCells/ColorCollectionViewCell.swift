//
//  ColorCollectionViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/01/05.
//

import UIKit


/**
 이 Cell은 ColorSettingViewController에 collectionView 속성의 재사용 Cell로 사용됩니다. 색상 데이터 소스를 Cell을 통해 화면에 보여줍니다.
 
 ColorSettingViewController의 collectionView속성에서 *dequeueReusableCell(withIdentifier:for:)* method를 호출할 때 이 Cell을 리턴합니다.
 */
class ColorCollectionViewCell: UICollectionViewCell {
    
    
    /**
     UIImageView입니다. 이 속성의 background 속성을 이용해 색을 구별합니다.
     */
    @IBOutlet weak var backgroundImageView: BorderImageView!
    
    
    /**
     선택을 할 경우 체크 이미지를 표시 할 UIImageView입니다.
     */
    @IBOutlet weak var checkImageView: UIImageView!
    
    
    /**
     테마의 이름이 표시될 UILabel입니다.
     */
    @IBOutlet weak var themeLabel: UILabel!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     collectionView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier = "ColorCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAccessibilityIdentifier()
        // checkImageView의 isHidden 속성을 true로 초기화합니다.
        checkImageView.isHidden = true
    }
    
    private func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }
    
    
    func setAccessibilityIdentifier() {
        checkImageView.accessibilityIdentifier = identifier(.checkImageView)
    }
    
    
}
