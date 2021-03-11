
import UIKit
import UserNotifications

class AddServiceTableViewController: UITableViewController {
    
    @IBOutlet weak var serviceImageView: BorderImageView!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var serviceNameTextField: UITextField! { didSet { serviceNameTextField.returnKeyType = .done } }
    @IBOutlet weak var paymentTextField: UITextField! { didSet { paymentTextField.returnKeyType = .done } }
    @IBOutlet weak var startDateSettingButton: UIButton!
    @IBOutlet weak var renewalDateSettingButton: UIButton!
    @IBOutlet weak var subscriptionNotificationStatusSwitch: UISwitch!
    @IBOutlet weak var deleteButtonContainerView: ShadowView!
    @IBOutlet weak var saveButtonContainerView: ShadowView!
    @IBOutlet weak var saveButton: UIButton!
    
    var index: Int { UserDefaults.standard.integer(forKey: "selectedIndex") }
    var theme: CustomColor.Theme { CustomColor.shared.themes[self.index] }
    
    var savedService: SavedServiceEntity?
    var selectedCategory: String?
    var serviceNameText: String?
    var serviceEnglishNameText: String = ""
    var selectedImage: UIImage?
    var selectedImageURLString: String?
    var startDate: Date?
    var renewalDate: String?
    
    func changeTintColor() {
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(rgb: theme.sub1)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: theme.sub1)
        serviceNameTextField.textColor = UIColor(rgb: theme.sub1)
        categorySegmentedControl.hideBackground()
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(rgb: theme.sub1)], for: .selected)
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        paymentTextField.textColor = UIColor(rgb: theme.sub1)
        startDateSettingButton.tintColor = UIColor(rgb: theme.sub1)
        renewalDateSettingButton.tintColor = UIColor(rgb: theme.sub1)
        subscriptionNotificationStatusSwitch.onTintColor = UIColor(rgb: theme.sub1)
        
        guard savedService != nil else { return }
        saveButton.setTitleColor(UIColor(rgb: theme.sub1), for: .normal)
        saveButtonContainerView.backgroundColor = UIColor(rgb: theme.sub1)
    }
    
    @IBAction func goBack(_ sender: Any) {
        defer { navigationController?.popViewController(animated: true) }
        guard let serviceNameTextFieldText = serviceNameTextField.text else { return }
        guard let paymentTextFieldText = paymentTextField.text else { return }
        
        if let savedService = savedService {
            guard serviceNameTextFieldText != savedService.koreanName ||
                    paymentTextFieldText != savedService.amountOfPayment ||
                    startDate != savedService.subscriptionStartDate ||
                    renewalDate != savedService.subscriptionRenewalDate  else { return }
            
            showUpdateCaution { _ in self.save(sender) }
        }
    }
    
    
    @IBAction func turnOnPushAlert(_ sender: UISwitch) {
        if !(sender.isOn) {
            guard let name = serviceNameTextField.text else { return }
            UNUserNotificationCenter.current().removeLocalNotification(with: name)
        }
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        guard var inputServiceName = serviceNameTextField.text,
              var inputPayment = paymentTextField.text else { return }
        
        let segIndex = categorySegmentedControl.selectedSegmentIndex
        let selectedCategory = categorySegmentedControl.titleForSegment(at: segIndex) ?? "기타"
        
        if let savedService = savedService {
            CoreDataManager.shared.update(savedService,
                                          category: selectedCategory,
                                          name: inputServiceName,
                                          englishName: serviceEnglishNameText,
                                          imageURLString: selectedImageURLString ?? "",
                                          payment: inputPayment,
                                          startDate: startDate ?? Date(),
                                          renewalDate: renewalDate ?? "1개월",
                                          pushOn: subscriptionNotificationStatusSwitch.isOn)
            NotificationCenter.default.post(name: .serviceDidUpdate, object: nil)
            navigationController?.popViewController(animated: true)
            
        } else {
            if inputServiceName.isEmpty {
                inputServiceName = "이름없는 서비스"
            }
            if inputPayment.isEmpty {
                inputPayment = "0".numberFormattedString(.currency)
            }
            CoreDataManager.shared.add(category: selectedCategory,
                                       name: inputServiceName,
                                       englishName: serviceEnglishNameText,
                                       imageURLString: selectedImageURLString ?? "",
                                       payment: inputPayment,
                                       startDate: startDate ?? Date(),
                                       renewalDate: renewalDate ?? "1개월",
                                       pushOn: subscriptionNotificationStatusSwitch.isOn)
            NotificationCenter.default.post(name: .serviceDidAdd, object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func selectCategory(_ sender: Any) {
        paymentTextField.resignFirstResponder()
        serviceNameTextField.resignFirstResponder()
    }
    
    @IBAction func deleteSavedData(_ sender: Any) {
        guard let savedServiceName = savedService?.koreanName else { return }
        showDeleteCaution(serviceName: savedServiceName) { _ in
            CoreDataManager.shared.delete(self.savedService)
            NotificationCenter.default.post(name: .serviceDidDelete, object: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func changeButtonColor() {
        self.saveButton.isEnabled = true
        self.saveButton.setTitleColor(UIColor(rgb: self.theme.sub1), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.saveButtonContainerView.backgroundColor = UIColor(rgb: self.theme.sub1)
        }
        
    }
    
    func changeButtonStatus() {
        UIView.animate(withDuration: 0.35) { self.navigationController?.view.alpha = 0.90 }
        
        if renewalDate != nil {
            NotificationCenter.default.addObserver(forName: .startDateDidSelecte, object: nil, queue: .main) { _ in
                self.changeButtonColor()
            }
        } else if startDate != nil {
            NotificationCenter.default.addObserver(forName: .renewalDateDidSelecte, object: nil, queue: .main) { _ in
                self.changeButtonColor()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        paymentTextField.resignFirstResponder()
        serviceNameTextField.resignFirstResponder()
        
        if let startDateSettingViewController = segue.destination as? StartDateSettingViewController {
            startDateSettingViewController.delegate = self
            startDateSettingViewController.startDate = self.startDate
            changeButtonStatus()
        } else if let renewalDateSettingViewController = segue.destination as? RenewalDateSettingViewController {
            renewalDateSettingViewController.delegate = self
            changeButtonStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        changeTintColor()
        
        NotificationCenter.default.addObserver(forName: .imageDidSelecte, object: nil, queue: .main) { (notification) in
            if let imageURLString = notification.userInfo?["imageURLString"] as? String {
                imageURLString.getImage { self.serviceImageView.image = UIImage(data: $0) }
                self.selectedImageURLString = imageURLString
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        paymentTextField.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        saveButtonContainerView.layer.opacity = 0.2
        deleteButtonContainerView.isHidden = (savedService == nil)
        
        DispatchQueue.main.async {
            self.serviceImageView.image = self.selectedImage
        }

        if let savedService = savedService {
            saveButton.isEnabled = true
            saveButton.setTitle("저장", for: .normal)
            selectedCategory = savedService.category
            serviceNameTextField.text = savedService.koreanName
            paymentTextField.text = savedService.amountOfPayment
            subscriptionNotificationStatusSwitch.isOn = savedService.notificationIsOn
            serviceEnglishNameText = savedService.englishName ?? ""
        } else {
            serviceNameTextField.text = serviceNameText
            subscriptionNotificationStatusSwitch.isOn = false
            categorySegmentedControl.selectedSegmentIndex = 3
        }
        
        switch selectedCategory {
        case "OTT":
            categorySegmentedControl.selectedSegmentIndex = 0
        case "음악":
            categorySegmentedControl.selectedSegmentIndex = 1
        case "사무":
            categorySegmentedControl.selectedSegmentIndex = 2
        default:
            categorySegmentedControl.selectedSegmentIndex = 3
        }
        
        guard let savedStartDate = savedService?.subscriptionStartDate else { return }
        startDate = savedStartDate
        startDateSettingButton.setTitle(savedStartDate.formattedString(), for: .normal)
        
        guard let savedRenewalDate = savedService?.subscriptionRenewalDate else { return }
        renewalDate = savedRenewalDate
        renewalDateSettingButton.setTitle(savedRenewalDate, for: .normal)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5
    }
}


extension AddServiceTableViewController: UIGestureRecognizerDelegate {
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        serviceNameTextField.resignFirstResponder()
        paymentTextField.resignFirstResponder()
    }
}

extension AddServiceTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == paymentTextField else { return true }
        guard let nsString = textField.text as NSString? else { return true }
        let finalString = nsString.replacingCharacters(in: range, with: string)
        
        if finalString.count >= 12 {
            textField.textColor = .systemRed
            return false
        } else {
            textField.textColor = UIColor(rgb: theme.sub1)
        }
        
        textField.text = finalString.numberFormattedString(.currency)
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension AddServiceTableViewController: DateSettingViewControllerDelegate {
    func dateSettingViewController(_ viewController: UIViewController, startDate: Date?) {
        guard let startDate = startDate else { return }
        self.startDate = startDate
        startDateSettingButton.setTitle(startDate.formattedString(), for: .normal)
    }
    
    func dateSettingViewController(_ viewController: UIViewController, renewalDate: String) {
        self.renewalDate = renewalDate
        renewalDateSettingButton.setTitle(renewalDate, for: .normal)
    }
    
    func dateSettingViewController(_ viewController: UIViewController, alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.navigationController?.view.alpha = alpha
        }
    }
}

