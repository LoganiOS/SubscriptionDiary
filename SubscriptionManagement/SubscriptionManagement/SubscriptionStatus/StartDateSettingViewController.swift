
import UIKit

class StartDateSettingViewController: UIViewController {
    
    @IBOutlet weak var startDateSettingDatePicker: UIDatePicker!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: DateSettingViewControllerDelegate?
    
    var startDate: Date?
    
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(rgb: CustomColor.shared.themes[index].main)
        saveButton.tintColor = customTintColor

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
        startDate = startDateSettingDatePicker.date
        delegate?.dateSettingViewController(self, startDate: startDate)
        NotificationCenter.default.post(name: .startDateDidSelecte, object: nil)
        dismiss(sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDateSettingDatePicker.datePickerMode = .date
        startDateSettingDatePicker.date = startDate ?? Date()
        startDateSettingDatePicker.maximumDate = Date()
        
        changeTintColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
