//
//  PaymentDateStatusViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit
import JTAppleCalendar

class PaymentDateStatusViewController: UIViewController {

    @IBOutlet weak var favoriteCategoryTableView: UITableView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            monthLabel.text = "\(Date().month)월"
        }
    }
    
    var savedServicesSortedBySelectedDate = [SavedServiceEntity]()
    var selectedDate: Date? = Date()
    var savedServicesSortedByDate: [SavedServiceEntity] {
        return CoreDataManager.shared.list.sorted { $0.nextPaymentDate ?? Date() < $1.nextPaymentDate ?? Date() }
    }
    
    var thisMonthServiceCategoriesTotalPayment: Int {
        return CoreDataManager.shared.thisMonthServiceCategories.values.reduce(0, +)
    }
    
    struct ServiceNextPaymentDate {
        let serviceName: String
        let nextPaymentDate: String
    }
    
    var serviceNextPaymentDate: [ServiceNextPaymentDate] {
        var nextPaymentDate = [ServiceNextPaymentDate]()
        if !(CoreDataManager.shared.list.isEmpty) {
            CoreDataManager.shared.list.forEach { (service) in
                nextPaymentDate.append(ServiceNextPaymentDate(serviceName: service.koreanName ?? "",
                                                              nextPaymentDate: service.nextPaymentDate?.formattedString() ?? "" ))
            }
        }
        return nextPaymentDate
    }
    
    var didEndScroll = false
    
    func callCalendarView() -> JTACMonthView?  {
        guard let calendarTableViewCell = favoriteCategoryTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalendarTableViewCell else { return nil }
        
        return calendarTableViewCell.calendarView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteCategoryTableView.contentInset.top = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defer { favoriteCategoryTableView.reloadData() }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        guard !(CoreDataManager.shared.list.isEmpty) else { return }
        for i in 0..<CoreDataManager.shared.list.count {
            CoreDataManager.shared.list[i].nextPaymentDate = CoreDataManager.shared.list[i].subscriptionStartDate?
                .calculatingPaymentDays(
                    CoreDataManager.shared.list[i].subscriptionRenewalDate ?? "1개월").first
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        callCalendarView()?.reloadData()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK:- FIX ME!!!!
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.view.frame.width > self.view.frame.height ? self.callCalendarView()?.reloadData() : self.callCalendarView()?.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        savedServicesSortedBySelectedDate = [SavedServiceEntity]()
        selectedDate = nil
        
        didEndScroll = false
    }
}



// MARK:- UITableViewDataSource, UITableViewDelegate
extension PaymentDateStatusViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as? CalendarTableViewCell {
                let index = UserDefaults.standard.integer(forKey: "selectedIndex")
                let theme = CustomColor.shared.themes[index]
                
                underlineView.backgroundColor = UIColor(rgb: theme.sub2)
                monthLabel.textColor = UIColor(rgb: theme.main)
    
                cell.saturdayLabel.textColor = UIColor(rgb: theme.sub1)
                cell.sundayLabel.textColor = UIColor(rgb: theme.sub1)
  
                return cell
            }
        
        case 1:
            if CoreDataManager.shared.list.isEmpty {
                return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "DDayTableViewCell", for: indexPath) as? DDayTableViewCell {
                    return cell
                }
            }
            
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCategoryTableViewCell", for: indexPath) as? FavoriteCategoryTableViewCell {
                cell.changeTintColor()
                if self.favoriteCategoryTableView.contentOffset.y > 180 {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 2) {
                            cell.changeTintColorWhenReachedEnd()
                            self.view.layoutIfNeeded()
                        }
                    }
                }
                return cell
            }
            
        default:
            break
        }
        #if DEBUG
        fatalError()
        #else
        return UITableViewCell()
        #endif
    }

    // FIX 이거 별도로 빼기 (테이블뷰 델리게이트가 아님)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.favoriteCategoryTableView.contentOffset.y > 40 && didEndScroll == false {
            didEndScroll = true
            DispatchQueue.main.async {
                UIView.animate(withDuration: 2) {
                    if let tableView = scrollView as? UITableView {
                        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? FavoriteCategoryTableViewCell {
                            cell.changeTintColorWhenReachedEnd()
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
}


// MARK:- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PaymentDateStatusViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedServicesSortedBySelectedDate.isEmpty ? CoreDataManager.shared.list.count : savedServicesSortedBySelectedDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DDayCollectionViewCell",
                                                            for: indexPath) as? DDayCollectionViewCell else {
            #if DEBUG
            fatalError()
            #else
            return UITableViewCell()
            #endif
        }
        
        let selectedDates = savedServicesSortedBySelectedDate.isEmpty ? savedServicesSortedByDate : savedServicesSortedBySelectedDate

        let selectedDate = selectedDates[indexPath.item]
        cell.serviceNameLabel.text = selectedDate.koreanName
        
        if let imageURLString = selectedDate.imageURLString, imageURLString.count < 1 {
            cell.serviceImageView.image = UIImage(named: "DefaultImage")
        } else if let _ = selectedDate.imageURLString  {
            selectedDate.imageURLString?.getImage { cell.serviceImageView.image = UIImage(data: $0) }
        }
        
        let calendar = Calendar.current
        let now = Date()
        let fromDate = calendar.startOfDay(for: now)
        let toDate = calendar.startOfDay(for: selectedDates[indexPath.item].nextPaymentDate ?? now)
        let day = calendar.dateComponents([.day], from: fromDate, to: toDate).day ?? 0
        
        cell.dDayCountLabel.text = "D-\(day)"
        
        return cell  
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowlayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        let sectionInset = flowlayout.sectionInset
        return CGSize(width: collectionView.frame.height * 0.6,
                      height: collectionView.frame.height - (sectionInset.top + sectionInset.bottom))
    }
}


// MARK:- JTACMonthViewDataSource, JTACMonthViewDelegate, JTACCellMonthViewDelegate
extension PaymentDateStatusViewController: JTACMonthViewDataSource, JTACMonthViewDelegate, JTACCellMonthViewDelegate {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let now = Date()
        let maximumDate = Date(year: now.year, month: now.month+1, day: now.day) ?? Date()
        
        return ConfigurationParameters(startDate: now, endDate: maximumDate)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell ?? DateCell()
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let hexCode = CustomColor.shared.themes[index].sub2
        
        UIView.animate(withDuration: 0.1) {
            cell.paymentDotView.backgroundColor = (date == self.selectedDate) ? UIColor(rgb: hexCode) : UIColor.clear
            cell.paymentDotView.borderColor = UIColor(rgb: hexCode)
        }
        
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendarDidScroll(_ calendar: JTACMonthView) {
        let originalLabel = monthLabel.text
        monthLabel.text = "\(calendar.visibleDates().monthDates.first?.date.month ?? 0)월"
        if monthLabel.text != originalLabel {
            let animation = CATransition()
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.push
            monthLabel.layer.add(animation, forKey: CATransitionType.push.rawValue)
            
            calendar.deselectAllDates()
            self.selectedDate = nil
        }
    }
    
    func reloadDdayCollectionViewWithAnimate() {
        let indexPath = IndexPath(row: 1, section: 0)
        if let dDayTableViewCell = favoriteCategoryTableView.cellForRow(at: indexPath) as? DDayTableViewCell {
            UIView.transition(with: dDayTableViewCell.dDayCollectionView,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { dDayTableViewCell.dDayCollectionView.reloadData() },
                              completion: nil)
        }
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return cellState.dateBelongsTo == .thisMonth ? true : false
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        self.selectedDate = date
        
        let dates = calendar.selectedDates
        let finalDate = dates.filter { $0 != date }
        if calendar.selectedDates.count == 2 { calendar.deselect(dates: finalDate) }
        
        savedServicesSortedBySelectedDate = CoreDataManager.shared.list.filter {
            $0.nextPaymentDate?.formattedString() == date.formattedString()
        }
        
        calendar.reloadData()
        reloadDdayCollectionViewWithAnimate()
        
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
        if date == selectedDate { self.selectedDate = Date() }
        savedServicesSortedBySelectedDate = [SavedServiceEntity]()
        calendar.reloadData()
        reloadDdayCollectionViewWithAnimate()
        
    }
    
    func monthView(_ monthView: JTACCellMonthView, drawingFor segmentRect: CGRect, with date: Date, dateOwner: DateOwner, monthIndex: Int) {
        
    }
    
    func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        
    }
    
    func handleCellEvents(cell: DateCell, cellState: CellState) {
        let date = cellState.date
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        cell.todayCircleView.isHidden = (calendar.isDateInToday(date) && cellState.dateBelongsTo == .thisMonth) ? false : true
        cell.paymentDotView.isHidden = serviceNextPaymentDate.contains(where: { $0.nextPaymentDate == date.formattedString() }) ? false : true
    }
    
    func handleCellTextColor(cell: DateCell, cellState: CellState) {
        let date = cellState.date
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_kr")
        
        let theme = CustomColor.shared.themes[UserDefaults.standard.integer(forKey: "selectedIndex")]
        cell.todayCircleView.backgroundColor = UIColor(rgb: theme.main)
        
        if (calendar.isDateInWeekend(date) && cellState.dateBelongsTo == .thisMonth) {
            cell.dateLabel.alpha = 1
            cell.paymentDotView.alpha = 1
            cell.dateLabel.textColor = UIColor(rgb: theme.sub1)
        } else if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.alpha = 1
            cell.paymentDotView.alpha = 1
            
            if #available(iOS 13.0, *) {
                cell.dateLabel.textColor = UIColor.label
            } else {
                cell.dateLabel.textColor = UIColor.black
            }
            
        } else {
            cell.dateLabel.alpha = 0.3
            cell.paymentDotView.alpha = 0.3
            
            if #available(iOS 13.0, *) {
                cell.dateLabel.textColor = UIColor.systemGray2
            } else {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        }
    }
}
