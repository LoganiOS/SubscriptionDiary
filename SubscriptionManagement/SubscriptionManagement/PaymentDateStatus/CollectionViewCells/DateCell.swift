//
//  DateCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/18.
//

import UIKit
import JTAppleCalendar

class DateCell: JTACDayCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayCircleView: BorderView!
    @IBOutlet weak var paymentDotView: BorderView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.sizeToFit()
    }
}
