//
//  RenewalDateSettingViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit

class RenewalDateSettingViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: ShadowView!
    @IBOutlet weak var renewalDatePickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: DateSettingViewControllerDelegate?
    
    let dateCycle = [ (1...11).map{ String($0) }, ["주","개월","년"] ]
    
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(rgb: CustomColor.shared.themes[index].main)
        saveButton.tintColor = customTintColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTintColor()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        delegate?.dateSettingViewController?(self, alpha: 1)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissGesture(_ sender: UIPanGestureRecognizer) {
        let defaultPositionY: CGFloat = 0
        let velocity = sender.velocity(in: backgroundView)
        if velocity.y > defaultPositionY {
            dismiss(sender)
            return
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let selectedDate = dateCycle.first?[renewalDatePickerView.selectedRow(inComponent: 0)] else { return }
        guard let selectedCycle = dateCycle.last?[renewalDatePickerView.selectedRow(inComponent: 1)] else { return }
        
        delegate?.dateSettingViewController?(self, renewalDate: "\(selectedDate)\(selectedCycle)")
        NotificationCenter.default.post(name: .renewalDateDidSelecte, object: nil)
        
        dismiss(sender)
    }
    
}



// MARK: - UIPickerViewDataSource
extension RenewalDateSettingViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dateCycle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? dateCycle.first?.count ?? 0 : dateCycle.last?.count ?? 0
    }
    
}



// MARK: - UIPickerViewDelegate
extension RenewalDateSettingViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? dateCycle[component][row] : dateCycle[component][row]
    }
    
}
