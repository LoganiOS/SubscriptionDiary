//
//  ServiceListTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit


/**
 이 Cell을 통해 서비스목록을 ServiceListTableViewController에 표시할 수 있습니다.
 
 ServiceListTableViewController의 재사용 Cell로 사용됩니다.
 */
class ServiceListTableViewCell: UITableViewCell {
    
    /**
     서비스 로고를 표시할 UIImageView입니다.
     */
    @IBOutlet weak var logoImage: UIImageView!
    
    
    /**
     서비스 이름을 표시할 UILabel입니다.
     */
    @IBOutlet weak var serviceName: UILabel!
    
    
    /**
     Plus Circle 모양의 UIImageView입니다.
     */
    @IBOutlet weak var plusImageView: UIImageView!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     tableview의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier: String = "ServiceListTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(hex: CustomColor.shared.themes[index].main)
        plusImageView.tintColor = customTintColor
    }
    
}
