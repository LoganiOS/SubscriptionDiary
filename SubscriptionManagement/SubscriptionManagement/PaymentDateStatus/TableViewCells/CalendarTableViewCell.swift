//
//  CalendarTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/21.
//

import UIKit
import JTAppleCalendar

class CalendarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var calendarHeaderView: UIView!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    static let identifier = "CalendarTableViewCell"
    
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
