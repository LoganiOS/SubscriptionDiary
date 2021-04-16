//
//  FavoriteCategoryTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit


/**
 이 Cell은 favoriteCategoryTableView의 재사용 Cell로 사용됩니다. TableView에 사용자가 추가한 서비스현황을 그래프로 알려줍니다.
 
 PaymentDateStatusViewController의 favoriteCategoryTableView속성에서 *dequeueReusableCell(withIdentifier:for:)* method를 호출할 때 이 Cell을 리턴합니다. 아래와 같은 경우에서만 이 Cell을 리턴합니다.
 - indexPath.row가 2인 경우
 */
class FavoriteCategoryTableViewCell: UITableViewCell {
    

    /**
     그래프로 사용하기 위한 UIStackView입니다.
     
     이 Stack View에는 4개의 Border View(UIView)가 들어있습니다.
     */
    @IBOutlet weak var graphStackView: UIStackView!
    
    /**
     그래프 배경으로 사용하기 위한 UIStackView입니다.
     
     이 Stack View에는 4개의 Background Border View(UIView)가 들어있습니다.
     */
    @IBOutlet weak var graphBackgroundStackView: UIStackView!
    
    
    /**
     그래프 배경으로 사용하기 위한 UIStackView입니다.
     
     이 Stack View에는 4개의 Border View(UIView)가 들어있습니다. 각 Border View는 2개의 Label을 포함하고 있습니다.
     이 Label엔 각각 사용자가 추가한 카테고리와 카테고리별로 예상 결제 금액의 합계를 보여줍니다.
     */
    @IBOutlet weak var insightStackView: UIStackView!
    
    
    /**
     graphStackView에 포함된 첫번째 SubView의 높이 제약입니다.
     */
    @IBOutlet weak var firstConstraint: NSLayoutConstraint!
    
    
    /**
     graphStackView에 포함된 두번째 SubView의 높이 제약입니다.
     */
    @IBOutlet weak var secondConstraint: NSLayoutConstraint!
    
    
    /**
     graphStackView에 포함된 세번째 SubView의 높이 제약입니다.
     */
    @IBOutlet weak var thirdConstraint: NSLayoutConstraint!
    
    
    /**
     graphStackView에 포함된 네번째 SubView의 높이 제약입니다.
     */
    @IBOutlet weak var fourthConstraint: NSLayoutConstraint!
    
    
    /**
     UILabel입니다.
     
     titleLabel.text는 아래와 같은 값을 가지고 있습니다.
     ```
     "\(Date().month)월 이용현황"
     ```
     */
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "\(Date().month)월 이용현황"
        }
    }
    
    
    /**
     Cell의 identifier를 문자열로 저장한 타입 속성입니다.
     
     tableView의 *dequeueReusableCell(withIdentifier:for:)*  method를 호출할 때 withIdentifier 파라미터에 이 속성을 전달하세요.
     */
    static let identifier = "FavoriteCategoryTableViewCell"
    
    
    /**
     사용자가 추가한 서비스 중 결제 예상일이 이번 달에 포함된 모든 서비스의 예상 결제 금액을 합산하여 리턴합니다.
     */
    var all: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories.values.reduce(0, +)) }
    
    
    /**
     사용자가 추가한 서비스 중 결제 예상일이 이번 달에 포함된 OTT 서비스의 예상 결제 금액을 합산하여 리턴합니다.
     */
    var OTT: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["OTT"] ?? 0) }
    
    
    /**
     사용자가 추가한 서비스 중 결제 예상일이 이번 달에 포함된 music 서비스의 예상 결제 금액을 합산하여 리턴합니다.
     */
    var music: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["음악"] ?? 0) }
    
    
    /**
     사용자가 추가한 서비스 중 결제 예상일이 이번 달에 포함된 office 서비스의 예상 결제 금액을 합산하여 리턴합니다.
     */
    var office: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["사무"] ?? 0) }
    
    
    /**
     사용자가 추가한 서비스 중 결제 예상일이 이번 달에 포함된 others 서비스의 예상 결제 금액을 합산하여 리턴합니다.
     */
    var others: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["기타"] ?? 0) }
    
    
    /**
     사용자가 선택한 색상으로 뷰의 틴트컬러를 변경합니다.
     
     사용자가 선택한 색상의 index는 UserDefaults.standard.integer(forKey: "selectedIndex")에 저장되어 있습니다.
     CustomColor.shared.themes 배열에서 이 index값으로 사용자가 선택한 색상을 가져올 수 있습니다.
     */
    func changeTintColor() {
        let selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        let theme = CustomColor.shared.themes[selectedIndex]
        
        let colors = [UIColor(hex: theme.main),
                      UIColor(hex: theme.sub1),
                      UIColor(hex: theme.sub2),
                      UIColor(named: "Translucent Label Color")]
        
        let categoriesSortedByExpenses = CoreDataManager.shared.categoryExpenses
        
        /// 순서대로 색상 index를 전달합니다. 이 때 index 값이 3을 초과하지 않도록 주의합니다.
        var colorIndex = 0
        
        /// insightStackView의 카테고리를 표시하는 UILabel을 위해 사용될 index값입니다.
        var keyIndex = 0
       
        /// insightStackView의 합계를 표시하는 UILabel을 위해 사용될 index값입니다.
        var valueIndex = 0
        
        /// graphStackView의 색상 변경을 위해 사용될 index값입니다.
        var graphIndex = 0
        
        /// graphBackgroundStackView의 색상 변경을 위해 사용될 index값입니다.
        var backgroundIndex = 0
        
        self.titleLabel.textColor = colors[1]
        
        insightStackView.arrangedSubviews.forEach { (view) in
            view.backgroundColor = colors[colorIndex]
            
            if colorIndex < 3 { colorIndex += 1 }
            
            view.subviews.forEach { (view) in
                guard let label = view as? UILabel else { return }
                switch label.tag {
                case 101: // 카테고리를 표시하는 UILabel입니다.
                    guard keyIndex < categoriesSortedByExpenses.count else {
                        label.text = "-"
                        
                        return
                    }
                    
                    label.text = categoriesSortedByExpenses.map{ $0.key }[keyIndex]
                    
                    keyIndex += 1
                default: // 합계 금액을 표시하는 UILabel입니다.
                    guard valueIndex < categoriesSortedByExpenses.count else {
                        label.text = "-"
                        
                        return
                    }
                    
                    label.text = String(categoriesSortedByExpenses.map{ $0.value }[valueIndex]).numberFormattedString(.currency)
                    
                    valueIndex += 1
                }
            }
            
            graphStackView.arrangedSubviews.forEach { (view) in
                guard graphIndex < 4 else { return }
                view.backgroundColor = colors[graphIndex]

                graphIndex += 1
            }
            
            graphBackgroundStackView.arrangedSubviews.forEach { (view) in
                guard backgroundIndex < 4 else { return }
                view.backgroundColor = colors[backgroundIndex]
                
                backgroundIndex += 1
            }
        }
    }
    
    /**
     graphStackView의 색상을 변경함과 동시에 constant값을 변경합니다.
     
     반드시 아래의 조건에만 이 method를 호출해야합니다.
     - favoriteCategoryTableView.contentOffset.y > 180
     - animate duration이 2 이상인 경우
     
     이 method를 호출하고 변화가 없다면 *layoutIfNeeded()* method를 호출하세요.
     */
    @discardableResult
    func changeTintColorWhenReachedEnd() -> Bool {
        let selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        let theme = CustomColor.shared.themes[selectedIndex]
        let colors = [UIColor(hex: theme.main), UIColor(hex: theme.sub1),
                      UIColor(hex: theme.sub2), UIColor(named: "Custom Background Color")]

        /// 카테고리별로 예상 결제 금액 비율을 계산한 다음 결제 금액이 높은 순서대로 정렬한 배열입니다.
        let values: [CGFloat] = [OTT/all, music/all, office/all, others/all].sorted(by: >)
        
        var graphIndex = 0
        
        graphStackView.arrangedSubviews.forEach { (view) in
            guard graphIndex < 4 else { return }
            
            view.backgroundColor = colors[graphIndex]
            
            // 0/0 표현식을 평가하면 nan입니다. 이 경우 0을 리턴합니다.
            let comparisonValue = values[graphIndex].isNaN ? 0 : values[graphIndex] * 300
            
            switch graphIndex {
            case 0 :
                self.firstConstraint.constant = comparisonValue
            case 1 :
                self.secondConstraint.constant = comparisonValue
            case 2 :
                self.thirdConstraint.constant = comparisonValue
            case 3 :
                self.fourthConstraint.constant = comparisonValue
            default:
                break
            }
            
            graphIndex += 1
        }
        
        return true
    }
    
}
