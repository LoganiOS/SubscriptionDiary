//
//  RenewalDateSettingViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/15.
//

import UIKit


/**
 '구독 갱신일'을 지정할 수 있는 뷰 컨트롤러입니다.
 */
class RenewalDateSettingViewController: UIViewController {
    
    
    /**
     배경 전체에 깔려있는 UIView입니다.
     */
    @IBOutlet weak var backgroundView: ShadowView!
    
    
    /**
     '구독 갱신일'을 선택할 수 있는 UIPickerView입니다.
     */
    @IBOutlet weak var renewalDatePickerView: UIPickerView!
    
    
    /**
     renewalDatePickerView에 사용할 date source입니다.
     */
    let dateUnit = [ (1...11).map{ String($0) }, ["주","개월","년"] ]
    
    /**
     이 버튼을 탭하면 *save(:)* method가 호출됩니다.
     
     이 컨트롤의 속성은 아래와 같습니다.
     - Title: "선택"
     */
    @IBOutlet weak var saveButton: UIButton!
    
    
    /**
     DateSettingViewControllerDelegate 속성입니다.
     
     이 속성을 통해 AddServiceTableViewController에 구현된 DateSettingViewControllerDelegate 프로토콜 method를 호출할 수 있습니다.
     */
    var delegate: DateSettingViewControllerDelegate?
    

    /**
     사용자가 선택한 색상으로 뷰의 틴트컬러를 변경합니다.
     
     사용자가 선택한 색상의 index는 UserDefaults.standard.integer(forKey: "selectedIndex")에 저장되어 있습니다.
     CustomColor.shared.themes 배열에서 이 index값으로 사용자가 선택한 색상을 가져올 수 있습니다.
     */
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(hex: CustomColor.shared.themes[index].main)
        saveButton.tintColor = customTintColor
    }

    
    /**
     이 버튼을 탭하는 경우 AddServiceTableViewController로 alpha값을 전달하고 뷰 컨트롤러를 dismiss합니다.

     - Parameter sender: sender는 UIButton으로 타입캐스팅 할 수 있습니다.
     */
    @IBAction func dismiss(_ sender: Any) {
        delegate?.dateSettingViewController?(self, alpha: 1)
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /**
     backgroundView에서 실행된 제스처를 감지하고 화면을 dismiss합니다.
     
     - Parameter sender: UIPanGestureRecognizer
     */
    @IBAction func dismissGesture(_ sender: UIPanGestureRecognizer) {
        /**
         backgroundView에서 실행된 제스처의 방향 및 속도를 저장합니다.
         
         이 velocity의 y 속성이 0보다 크다면 아래로 향하는 제스쳐입니다.
         */
        let velocity = sender.velocity(in: backgroundView)
        
        if velocity.y > 0 {
            dismiss(sender)
            return
        }
    }
    
    
    /**
     사용자가 UIPickerView에서 선택한 문자열를 저장하고 AddServiceTableViewController에 전달 한 다음, 화면을 dismiss합니다.
     
     - Parameter sender: UIButton
     */
    @IBAction func save(_ sender: Any) {
        guard let selectedDate = dateUnit.first?[renewalDatePickerView.selectedRow(inComponent: 0)] else { return }
        guard let selectedCycle = dateUnit.last?[renewalDatePickerView.selectedRow(inComponent: 1)] else { return }
        
        delegate?.dateSettingViewController?(self, renewalDate: "\(selectedDate)\(selectedCycle)")
        NotificationCenter.default.post(name: .renewalDateDidSelecte, object: nil)
        
        dismiss(sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeTintColor()
    }
    
}



// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension RenewalDateSettingViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dateUnit.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? dateUnit.first?.count ?? 0 : dateUnit.last?.count ?? 0
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateUnit[component][row]
    }
    
    
}
