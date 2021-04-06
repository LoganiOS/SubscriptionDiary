//
//  SettingTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/01/05.
//

import UIKit


/**
 이 Cell은 SettingViewController에 listTableView 속성의 재사용 Cell로 사용됩니다. 설정의 목록을 Cell의 표시합니다.
 
 SettingViewController의 listTableView속성에서 *dequeueReusableCell(withIdentifier:for:)* method를 호출할 때 이 Cell을 리턴합니다.
 */
class SettingTableViewCell: UITableViewCell {
    
    
    /**
     설정의 목록을 저장할 UILabel입니다.
     */
    @IBOutlet weak var titleLabel: UILabel!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     tableView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier = "SettingTableViewCell"

    
}
