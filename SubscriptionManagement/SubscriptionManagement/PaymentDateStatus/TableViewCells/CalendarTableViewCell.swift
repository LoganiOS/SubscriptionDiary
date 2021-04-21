//
//  CalendarTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/21.
//

import UIKit
import JTAppleCalendar


/**
 이 Cell은 favoriteCategoryTableView의 재사용 Cell로 사용됩니다. TableView에 달력을 표시합니다.
 
 PaymentDateStatusViewController의 favoriteCategoryTableView속성에서 *dequeueReusableCell(withIdentifier:for:)* method를 호출할 때 이 Cell을 리턴합니다. 아래와 같은 경우에서만 이 Cell을 리턴합니다.
 - indexPath.row가 0인경우
 */
class CalendarTableViewCell: UITableViewCell {
    
    
    /**
     요일을 표시하는 UIView입니다.
     
     이 속성은 Stack View를 SubView로 가지고 있습니다. Stack View에는 요일을 표시하는 7개의 UILabel이 순서대로 포함되어 있습니다.
     */
    @IBOutlet weak var calendarHeaderView: UIView!
    
    
    /**
     토요일을 표시하는 UILabel입니다.
     
     이 Label의 속성은 아래와 같습니다.
     - text: "SAT"
     */
    @IBOutlet weak var saturdayLabel: UILabel!
    
    
    /**
     일요일을 표시하는 UILabel입니다.
     
     이 Label의 속성은 아래와 같습니다.
     - text: "SUN"
     */
    @IBOutlet weak var sundayLabel: UILabel!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     tableView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier = "CalendarTableViewCell"
    
    
    /**
     JTACMonthView 타입의 프로퍼티입니다. 화면에 달력을 표시합니다.
     
     이 속성을 사용하려면 JTAppleCalendar Framework를 import해야 합니다.
     collectionView로 구현되어 있으며 세부 속성은 아래와 같습니다.
     - backgroundColor: .clear
     - scrollingMode: stopAtEachCalendarFrame (월별로 스크롤)
     - scrollDirection: vertical (스크롤 방향: 수직/세로)
     */
    @IBOutlet weak var calendarView: JTACMonthView! {
        didSet {
            calendarView.backgroundColor = .clear
            calendarView.scrollingMode = .stopAtEachCalendarFrame
            calendarView.scrollDirection = .vertical
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        calendarView.allowsMultipleSelection = true
    }
    
    
}
