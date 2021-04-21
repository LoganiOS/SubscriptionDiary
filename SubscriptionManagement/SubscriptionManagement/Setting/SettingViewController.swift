//
//  SettingViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/01/05.
//

import UIKit


/**
 구독 기입장의 설정 화면(세번째 탭)입니다.
 */
class SettingViewController: UIViewController {

    
    /**
     설정 목록을 표시할 UITableView 속성입니다.
     */
    @IBOutlet weak var listTableView: UITableView!
    
    
    /**
     설정 Label 아래 밑줄을 표시하는 UIView입니다.
     */
    @IBOutlet weak var underLineView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        underLineView.backgroundColor = UIColor(hex: CustomColor.shared.themes[index].sub2)
        
        listTableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}



// MARK:- UITableViewDataSource, UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as! SettingTableViewCell

        return cell
    }
    
}
