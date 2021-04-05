//
//  SubscriptionStatusTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit


/**
 이 Cell을 통해 사용자가 추가한 서비스를 SubscriptionStatusViewController 뷰 컨트롤러에 표시할 수 있습니다.
 
 이 Cell은 subscriptionStatusTableView의 재사용 Cell로 사용됩니다.
 */
class SubscriptionStatusTableViewCell: UITableViewCell {
    
    
    /**
     서비스 로고를 표시할 UIImageView입니다.
     */
    @IBOutlet weak var logoImageView: BorderImageView!
    
    
    /**
     서비스 이름을 표시할 UILabel입니다.
     */
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    
    /**
     서비스 결제예상 금액을 표시할 UILabel입니다.
     */
    @IBOutlet weak var paymentLabel: UILabel!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     tableview의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier에 이 속성을 전달하세요.
     */
    static let identifier: String = "SubscriptionStatusTableViewCell"
    
}
