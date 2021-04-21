//
//  ColorSettingViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/01/05.
//

import UIKit


/**
 사용자는 이 뷰 컨트롤러에서 원하는 색상 테마를 설정하고 변경할 수 있습니다.
 */
class ColorSettingViewController: UIViewController {
    
    
    /**
     사용자가 선택한 색상의 index값입니다.
     
     *collectionView(_:didSelectItemAt:)* method가 호출될 때 UserDefaults.standard.setValue(index, forKey: "selectedIndex") 를 통해 사용자가 선택한 생상의 index값을 저장합니다.
     저장된 값은 UserDefaults.standard.integer(forKey: "selectedIndex")를 통해 리턴할 수 있습니다.
     */
    var index = UserDefaults.standard.integer(forKey: "selectedIndex")
    
    
    @IBOutlet weak var colorSettingCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAccessibilityIdentifier()
    }
    
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension ColorSettingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CustomColor.shared.themes.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as! ColorCollectionViewCell
        let customColor = CustomColor.shared.themes[indexPath.item]
        
        cell.backgroundImageView.backgroundColor = UIColor(hex: customColor.main)
        cell.themeLabel.text = customColor.name
        
        UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve) {
            cell.checkImageView.isHidden = indexPath.item != self.index
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.item
        
        // 사용자가 item을 선택할 때마다 선택된 index값을 저장합니다.
        UserDefaults.standard.setValue(index, forKey: "selectedIndex")
        
        let customTintColor = UIColor(hex: CustomColor.shared.themes[index].main)
        UIApplication.shared.windows.first?.tintColor = customTintColor
        self.tabBarController?.tabBar.tintColor = customTintColor
        
        collectionView.reloadData()
    }
    

}



// MARK: - UICollectionViewDelegateFlowLayout
extension ColorSettingViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        
        let width = ((collectionView.frame.width + (flowLayout.sectionInset.left / 2)) / 3) - flowLayout.sectionInset.right
        let height = 300 - flowLayout.sectionInset.top
        
        return CGSize(width: width, height: height)
    }
    
    
}



// MARK: - Accessiblility Identifier
extension ColorSettingViewController {
    
    
    private func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }
    
    func setAccessibilityIdentifier() {
        colorSettingCollectionView.accessibilityIdentifier = identifier(.colorCollectionView)
    }
    
    
}
