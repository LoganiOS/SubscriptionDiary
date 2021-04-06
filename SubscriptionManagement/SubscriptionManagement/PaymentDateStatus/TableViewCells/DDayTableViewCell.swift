//
//  DDayTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/18.
//

import UIKit


/**
 이 Cell은 favoriteCategoryTableView의 재사용 Cell로 사용됩니다. dDayCollectionView를 통해 사용자가 추가한 서비스의 D-Day를 표시합니다.
 
 PaymentDateStatusViewController의 favoriteCategoryTableView속성에서 *dequeueReusableCell(withIdentifier:for:)* method를 호출할 때 이 Cell을 리턴합니다. 아래와 같은 경우에서만 이 Cell을 리턴합니다.
 - indexPath.row가 1이면서 CoreDataManager.shared.list 배열의 요소가 1개 이상인 경우
 */
class DDayTableViewCell: UITableViewCell {
   
    
    /**
     이 collectionView 속성을 통해 Cell에 사용자가 추가한 서비스의 D-day를 표시합니다.
     
     이 속성은 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 DDayCollectionViewCell을 리턴합니다.
     */
    @IBOutlet weak var dDayCollectionView: UICollectionView!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     tableView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifer = "DDayTableViewCell"
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        dDayCollectionView.reloadData()
    }
}
