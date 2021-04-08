//
//  PaymentDateStatusViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit
import JTAppleCalendar


/**
 구독 기입장의 모아보기 화면(두번째 탭)입니다.
 
 favoriteCategoryTableView의 indexPath.row따라 데이터를 보여줍니다.
 - 0: 달력
 - 1: 사용자가 추가한 서비스를 결제일 순서대로 정렬해서 컬렉션 뷰에 표시
 - 2: 사용자가 추가한 서비스의 통계를 그래프로 표시
 */
class PaymentDateStatusViewController: UIViewController {
    
    
    /**
     ServiceNextPaymentDate 타입의 구조체입니다.
     
     사용자가 추가한 서비스 명과 서비스의 바로 직전의 결제 예상일을 속성에 저장할 수 있습니다.
     */
    struct ServiceNextPaymentDate {
        /// 서비스 명
        let serviceName: String
        
        /// 결제 예상일
        let nextPaymentDate: String
    }
    
    
    /**
     이 속성은 ServiceNextPaymentDate 타입의 배열입니다.
     
     사용자가 추가한 서비스가 없다면 (CoreDataManager.shared.list.isEmpty) 빈 배열을 리턴하고,
     사용자가 추가한 서비스가 있다면 서비스 명과 바로 다음 결제일만 문자열로 리턴합니다.
     */
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
    
    /**
     *calendar(_: didSelectDate:cell:cellState:indexPath:)* method가 호출될 때 이 속성에 선택된 날짜에 해당되는 서비스만 필터링 합니다.
     ```
     func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        CoreDataManager.shared.list.filter {
            $0.nextPaymentDate?.formattedString() == date.formattedString()
        }
     }
     ```
     viewDidDisappear(_ :)에서 이 속성값을 빈 배열로 변경해야 합니다.
     */
    var savedServicesSortedBySelectedDate = [SavedServiceEntity]()
    
    
    /**
     calendarView에서 선택된 날짜를 이 속성에 저장합니다.
     
     이 속성의 초기화 값은 Date() 입니다.
     */
    var selectedDate: Date? = Date()
    
    
    /**
     사용자가 추가한 서비스들을 다가오는 결제일 순서로 정렬한 배열입니다.
     */
    var savedServicesSortedByDate: [SavedServiceEntity] {
        return CoreDataManager.shared.list.sorted { $0.nextPaymentDate ?? Date() < $1.nextPaymentDate ?? Date() }
    }
    
    
    /**
     사용자가 추가한 서비스들 중 결제 예상일이 이번달에 포함된 서비스들만 필터링 한 다음, 예상 결제 금액을 합산한 값입니다.
     */
    var thisMonthServiceCategoriesTotalPayment: Int {
        return CoreDataManager.shared.thisMonthServiceCategories.values.reduce(0, +)
    }
    
    
    /**
     이 속성이 false 인 경우에만 *changeTintColorWhenReachedEnd()* method가 실행됩니다.
     
     반드시 *scrollViewDidScroll(_ :)*, *viewDidDisappear(_:)* method에서만 이 속성값을 변경하세요.
     */
    private var didEndScroll = false
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.favoriteCategoryTableView.contentOffset.y > 40 && didEndScroll == false {
            
            didEndScroll = true
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 2) {
                    if let tableView = scrollView as? UITableView {
                        if let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? FavoriteCategoryTableViewCell {
                            // graphStackView의 색상을 변경함과 동시에 constant값을 변경합니다.
                            cell.changeTintColorWhenReachedEnd()
                            
                            self.view.layoutIfNeeded()
                        }
                    }
                }
            }
        }
    }
    
    
    /**
     사용자가 추가한 서비스를 표시하기 위한 UITableView입니다.
     */
    @IBOutlet weak var favoriteCategoryTableView: UITableView!
    
    
    /**
     totalAmountOfPaymentLabel 아래, 밑줄을 표시하기 위한 UIView입니다.
     */
    @IBOutlet weak var underlineView: UIView!
    
    
    /**
     '월'을 표시하는 UILabel입니다. 기본값은 Date()속성의 '월'을 표시합니다.
     */
    @IBOutlet weak var monthLabel: UILabel! {
        didSet {
            monthLabel.text = "\(Date().month)월"
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteCategoryTableView.contentInset.top = 60
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        defer { favoriteCategoryTableView.reloadData() }
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        let savedservices = CoreDataManager.shared.list
        
        guard !(savedservices.isEmpty) else { return }
        
        for i in 0..<savedservices.count {
            savedservices[i].nextPaymentDate = savedservices[i].subscriptionStartDate?.calculatingPaymentDays(savedservices[i].subscriptionRenewalDate ?? "1개월").first
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        callCalendarView()?.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    
    // indexPath.row에 따라 아래의 Cell을 return합니다.
    // - 0: CalendarTableViewCell
    // - 1: DDayTableViewCell (데이터가 없는 경우 EmptyCell)
    // - 2: FavoriteCategoryTableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: CalendarTableViewCell.identifier, for: indexPath) as? CalendarTableViewCell {
                let index = UserDefaults.standard.integer(forKey: "selectedIndex")
                let theme = CustomColor.shared.themes[index]
                
                underlineView.backgroundColor = UIColor(hex: theme.sub2)
                monthLabel.textColor = UIColor(hex: theme.main)
                
                cell.saturdayLabel.textColor = UIColor(hex: theme.sub1)
                cell.sundayLabel.textColor = UIColor(hex: theme.sub1)
                
                return cell
            }
            
        case 1:
            if CoreDataManager.shared.list.isEmpty {
                return tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: DDayTableViewCell.identifer, for: indexPath) as? DDayTableViewCell {
                    return cell
                }
            }
            
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCategoryTableViewCell.identifier, for: indexPath) as? FavoriteCategoryTableViewCell {
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
    
}


// MARK:- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension PaymentDateStatusViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedServicesSortedBySelectedDate.isEmpty ? CoreDataManager.shared.list.count : savedServicesSortedBySelectedDate.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DDayCollectionViewCell.identifier,
                                                      for: indexPath) as! DDayCollectionViewCell
        
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
    
    /**
     CalendarTableViewCell의 calendarView 속성을 리턴합니다.
     
     Cell이 생성된 다음 이 method를 호출하세요.
     */
    func callCalendarView() -> JTACMonthView? {
        guard let calendarTableViewCell = favoriteCategoryTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CalendarTableViewCell else { return nil }
        
        return calendarTableViewCell.calendarView
    }
    
    
    // calendar의 날짜 범위 지정
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let now = Date()
        let maximumDate = Date(year: now.year, month: now.month+1, day: now.day) ?? Date()
        
        return ConfigurationParameters(startDate: now, endDate: maximumDate)
    }
    
    
    // JTACDayCell 타입 Cell 생성 담당
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: DateCell.identifier, for: indexPath) as! DateCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let hexCode = CustomColor.shared.themes[index].sub2
        
        UIView.animate(withDuration: 0.1) {
            cell.paymentDotView.backgroundColor = (date == self.selectedDate) ? UIColor(hex: hexCode) : UIColor.clear
            cell.paymentDotView.borderColor = UIColor(hex: hexCode)
        }
        
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
        
        return cell
    }
    
    /**
     JTACDayCell을 상속받은 DateCell Class의 초기화를 담당하는 method입니다.
     calendar(_ :willDisplay:forItemAt:cellState:indexPath:)에서 이 method를 호출하세요.
     
     - Parameter view: JTACDayCell 타입을 전달할 수 있습니다.
     - Parameter cellState: Cell의 상태를 전달할 수 있습니다.
     */
    private func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        
        cell.dateLabel.text = cellState.text
    }
    
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }
    
    
    // calendar가 scroll된 후에 호출
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
    
    /**
     dDayTableViewCell.dDayCollectionView을 reload할 때 transition 효과를 추가합니다.
     
     - duration: 0.2
     - options: .transitionCrossDissolve
     */
    private func reloadDdayCollectionViewWithAnimate() {
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
        if date == selectedDate {
            self.selectedDate = Date()
        }
        
        savedServicesSortedBySelectedDate = [SavedServiceEntity]()
        calendar.reloadData()
        reloadDdayCollectionViewWithAnimate()
        
    }
    
    
    func monthView(_ monthView: JTACCellMonthView, drawingFor segmentRect: CGRect, with date: Date, dateOwner: DateOwner, monthIndex: Int) {
        // 필수 method
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
        cell.todayCircleView.backgroundColor = UIColor(hex: theme.main)
        
        if (calendar.isDateInWeekend(date) && cellState.dateBelongsTo == .thisMonth) {
            cell.dateLabel.alpha = 1
            cell.paymentDotView.alpha = 1
            cell.dateLabel.textColor = UIColor(hex: theme.sub1)
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
