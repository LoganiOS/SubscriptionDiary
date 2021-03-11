//
//  FavoriteCategoryTableViewCell.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit

class FavoriteCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "\(Date().month)월 이용현황"
        }
    }
    @IBOutlet weak var graphStackView: UIStackView!
    @IBOutlet weak var graphBackgroundStackView: UIStackView!
    @IBOutlet weak var insightStackView: UIStackView!
    @IBOutlet weak var firstConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthConstraint: NSLayoutConstraint!
    
    var all: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories.values.reduce(0, +)) }
    var OTT: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["OTT"] ?? 0) }
    var music: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["음악"] ?? 0) }
    var office: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["사무"] ?? 0) }
    var others: CGFloat { CGFloat(CoreDataManager.shared.thisMonthServiceCategories["기타"] ?? 0) }
    
    func changeTintColor() {
        let selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        let theme = CustomColor.shared.themes[selectedIndex]
        let colors = [UIColor(rgb: theme.main), UIColor(rgb: theme.sub1),
                      UIColor(rgb: theme.sub2), UIColor(named: "Translucent Label Color")]
        
        let categoriesSortedByExpenses = CoreDataManager.shared.categoryExpenses
        
        var colorIndex = 0
        var keyIndex = 0
        var valueIndex = 0
        var graphIndex = 0
        var backgroundIndex = 0
        
        self.titleLabel.textColor = colors[1]
        
        insightStackView.arrangedSubviews.forEach { (view) in
            view.backgroundColor = colors[colorIndex]
            
            if colorIndex < 3 { colorIndex += 1 }
            
            view.subviews.forEach { (view) in
                guard let label = view as? UILabel else { return }
                switch label.tag {
                case 101:
                    guard keyIndex < categoriesSortedByExpenses.count else { label.text = "-"; return }
                    label.text = categoriesSortedByExpenses.map({ $0.key})[keyIndex]
                    keyIndex += 1
                default:
                    guard valueIndex < categoriesSortedByExpenses.count else { label.text = "-"; return }
                    label.text = String(categoriesSortedByExpenses.map({ $0.value})[valueIndex]).numberFormattedString(.currency)
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
    
    func changeTintColorWhenReachedEnd() {
        let selectedIndex = UserDefaults.standard.integer(forKey: "selectedIndex")
        let theme = CustomColor.shared.themes[selectedIndex]
        let colors = [UIColor(rgb: theme.main), UIColor(rgb: theme.sub1),
                      UIColor(rgb: theme.sub2), UIColor(named: "Custom Background Color")]

        let values: [CGFloat] = [OTT/all, music/all, office/all, others/all].sorted(by: >)
        
        var graphIndex = 0
        graphStackView.arrangedSubviews.forEach { (view) in
            guard graphIndex < 4 else { return }
            view.backgroundColor = colors[graphIndex]
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
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
