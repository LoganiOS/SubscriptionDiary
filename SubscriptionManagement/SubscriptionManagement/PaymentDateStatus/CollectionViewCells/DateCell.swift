//
//  DateCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/18.
//

import UIKit
import JTAppleCalendar


/**
 이 Cell은 달력을 표시하는 calendarView의 Cell로 사용됩니다.
 
 CalendarTableViewCell의 calendarView속성에서 *dequeueReusableCell(withIdentifier:for:)* method를 호출할 때 이 Cell을 리턴합니다. JTAppleCalendar 프레임워크에서 제공하는 Cell 타입입니다.
 */
class DateCell: JTACDayCell {
    
    
    /**
     날짜를 표시하는 UILabel입니다.
     */
    @IBOutlet weak var dateLabel: UILabel!
    
    
    /**
     날짜가 Date() 값과 일치하는 경우 이 UIView를 표시합니다.
     */
    @IBOutlet weak var todayCircleView: BorderView!
    
    
    /**
     날짜가 사용자가 추가한 결제일과 일치하는 경우 이 UIView를 표시합니다.
     */
    @IBOutlet weak var paymentDotView: BorderView!
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     collectionView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier = "DateCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.sizeToFit()
    }
}
