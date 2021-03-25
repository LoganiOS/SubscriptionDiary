//
//  ColorSettingViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/01/05.
//

import UIKit

class ColorSettingViewController: UIViewController {
    
    var index = UserDefaults.standard.integer(forKey: "selectedIndex")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

extension ColorSettingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        CustomColor.shared.themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        let customColor = CustomColor.shared.themes[indexPath.item]
        
        cell.backgroundImageView.backgroundColor = UIColor(rgb: customColor.main)
        cell.themeLabel.text = customColor.name
        
        UIView.transition(with: collectionView, duration: 0.25, options: .transitionCrossDissolve) {
            cell.checkImageView.isHidden = indexPath.item != self.index
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.item
        UserDefaults.standard.setValue(index, forKey: "selectedIndex")
        UserDefaults.standard.synchronize()
        
        let customTintColor = UIColor(rgb: CustomColor.shared.themes[index].main)
        UIApplication.shared.windows.first?.tintColor = customTintColor
        self.tabBarController?.tabBar.tintColor = customTintColor
        
        collectionView.reloadData()
    }
    

}



//
extension ColorSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        
        // FIX
        return CGSize(width: (collectionView.frame.width + (flowLayout.sectionInset.left / 2)) / 3 - flowLayout.sectionInset.right,
                      height: 300 - flowLayout.sectionInset.top)
    }
}
