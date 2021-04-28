//
//  AddServiceTableViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit
import UserNotifications


/**
 서비스를 추가하기 위한 뷰 컨트롤러입니다.
 
 이전 화면이 ServiceListTableViewController인 경우
 - TableView Cell에서 선택해 진입한 경우 : 선택한 서비스를 기준으로 해당 서비스의 이미지와 서비스 명이 초기화합니다.
 - 직접추가 버튼을 탭해 진입한 경우 : 기본 이미지만 초기화합니다.
 
 이전 화면이 SubscriptionStatusViewController인 경우
 - 사용자가 입력한 정보를 기준으로 모든 속성을 초기화합니다.
 */
class AddServiceTableViewController: CommonTableViewController {
    
    
    var coreDataManager = CoreDataManager.shared
    
    /**
     사용자가 추가 또는 수정 할 서비스와 연관된 이미지를 지정할 수 있습니다.
     
     사용자는 IconChangeViewController에서 이미지를 선택하면, 이 속성을 변경할 수 있습니다.
     */
    @IBOutlet weak var serviceImageView: BorderImageView!
    
    
    /**
     이 버튼을 탭하면 IconChangeViewController 로 이동합니다.
     */
    @IBOutlet weak var iconChangeButton: UIButton!
    
    
    /**
     사용자가 추가 또는 수정 할 서비스 명의 이름을 입력하는 TextField입니다.
     
     returnKeyType 속성값을 .done으로 저장합니다.
     */
    @IBOutlet weak var serviceNameTextField: UITextField! {
        didSet {
            serviceNameTextField.returnKeyType = .done
        }
    }
    
    
    /**
     사용자가 추가 또는 수정 할 서비스의 카테고리를 지정할 수 있습니다.
     */
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    
    /**
     사용자가 추가 또는 수정 할 서비스의 결제 예상 금액을 입력하는 TextField입니다.
     
     returnKeyType 속성값을 .done으로 저장합니다.
     */
    @IBOutlet weak var paymentTextField: UITextField! {
        didSet {
            paymentTextField.returnKeyType = .done
        }
    }
    
    
    /**
     사용자가 추가 또는 수정 할 서비스의 '구독 시작일/결제일'을 지정할 수 있습니다.
     
     이 버튼은 StartDateSettingViewController 화면으로 이동하는 Segue를 실행합니다.
     StartDateSettingViewController의 DatePickerView에서 Date를 선택할 경우 선택한 날짜를 이 버튼의 title로 저장합니다.
     */
    @IBOutlet weak var startDateSettingButton: UIButton!
    
    
    /**
     사용자가 추가 또는 수정 할 서비스의 '갱신주기'을 지정할 수 있습니다.
     
     이 버튼은 RenewalDateSettingViewController 화면으로 이동하는 Segue를 실행합니다.
     RenewalDateSettingViewController의 PickerView에서 갱신주기를 선택할 경우 선택한 주기를 이 버튼의 title로 저장합니다.
     */
    @IBOutlet weak var renewalDateSettingButton: UIButton!
    
    
    /**
     결제 예상일 하루 전 Push Notification 알람을 받기 위한 UISwitch입니다.
     
     사용자가 이 속성을 true로 설정한 경우 true인 서비스에 한해 결제 예상일 하루 전 오후 2시에 Push 알림이 실행됩니다.
     */
    @IBOutlet weak var subscriptionNotificationStatusSwitch: UISwitch!
    
    
    /**
     @IBAction func deleteSavedData()와 연결된 버튼의 백그라운드 뷰입니다.
     
     이 속성은 ServiceListTableViewController를 통해 진입한 경우에만 표시됩니다.
     */
    @IBOutlet weak var deleteButtonContainerView: ShadowView!
    
    
    /**
     saveButton과 연결된 버튼의 백그라운드 뷰입니다.
     */
    @IBOutlet weak var saveButtonContainerView: ShadowView!
    
    
    /**
     이 버튼을 탭하는 경우 사용자가 입력한 데이터를 저장합니다.
     
     이 버튼을 탭하는 경우 *save()* method가 호출되고 사용자가 입력한 데이터를 CoreData에 저장합니다.
     이미 데이터가 입력되어 있는 경우, 기존 데이터를 수정해서 저장합니다.
     */
    @IBOutlet weak var saveButton: UIButton!
    
    
    /**
     사용자가 선택한 컬러테마의 인덱스값을 불러옵니다.
     
     이 속성은 CustomColor.shared.themes의 index 용도로만 사용해야 합니다.
     */
    var index: Int { UserDefaults.standard.integer(forKey: "selectedIndex") }
    
    
    /**
     index값을 통해 사용자가 선택한 컬러테마를 불러옵니다.
     */
    var theme: CustomColor.Theme { CustomColor.shared.themes[self.index] }
    
    
    /**
     이 속성에 값이 저장되어 있는 경우 해당 속성을 통해 AddServiceTableViewController 내용을 초기화합니다. 값이 nil인 경우 viewDidLoad()에서 직접 초기화를 진행합니다.
     */
    var savedService: SavedServiceEntity?
    
    
    /**
     categorySegmentedControl에 사용되는 속성입니다. ServiceListTableViewController의 *prepare(for:sender:)* method에서 이 속성값을 초기화합니다.
     
     사용자가 cell(UITableViewCell)을 탭해 화면을 이동하는 경우
     - 선택된 서비스의 카테고리를 이 속성에 저장합니다.
     - viewDidLoad()에서 이 속성과 일치여부에 따라 categorySegmentedControl.selectedSegmentIndex의 값을 변경합니다.
     
     사용자가 직접추가 버튼(UIBarButtonItem)을 탭해 화면을 이동하는 경우
     - 아무 값도 저장하지 않습니다.
     - 저장되어있는 값이 없는 경우 viewDidLoad()에서 categorySegmentedControl.selectedSegmentIndex의 값을 3으로 변경합니다.
     */
    var selectedCategory: String?
    
    
    /**
     serviceNameTextField(서비스 명)에 표시되는 속성입니다. ServiceListTableViewController의 *prepare(for:sender:)* method에서 이 속성값을 초기화합니다.
     
     사용자가 cell(UITableViewCell)을 탭해 화면을 이동하는 경우
     - 선택된 서비스의 koreanName값을 이 속성에 저장합니다.
     
     사용자가 직접추가 버튼(UIBarButtonItem)을 탭해 화면을 이동하는 경우
     - TextField의 PlaceHolder("Name")가 표시됩니다.
     */
    var serviceNameText: String?
    
    
    /**
     추가 또는 수정할 서비스의 englishName 속성을 저장합니다.
     
     이 속성은 UI에 표시되진 않지만, 사용자가 서비스를 검색할 때 필요한 속성입니다.
     */
    var serviceEnglishNameText: String = ""
    
    
    /**
     사용자가 선택한 이미지를 이 속성에 저장합니다.
     */
    var selectedImage: UIImage?
    
    
    /**
     사용자가 선택한 이미지의 URL을 이 속성에 저장합니다.
     */
    var selectedImageURLString: String?
    
    
    /**
     사용자가 선택한 구독 시작일을 이 속성에 저장합니다.
     */
    var startDate: Date?
    
    
    /**
     사용자가 선택한 갱신주기를 이 속성에 저장합니다.
     */
    var renewalDate: String?
    
    
    /**
     속성에 accessibilityIdentifier를 부여합니다.
     */
    func setAccessibilityIdentifier() {
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = identifier(.backButton)
        tableView.accessibilityIdentifier = identifier(.addServiceTableView)
        serviceNameTextField.accessibilityIdentifier = identifier(.nameField)
        categorySegmentedControl.accessibilityIdentifier = identifier(.categorySeg)
        paymentTextField.accessibilityIdentifier = identifier(.payField)
        startDateSettingButton.accessibilityIdentifier = identifier(.startDateButton)
        renewalDateSettingButton.accessibilityIdentifier = identifier(.renewalDateButton)
        subscriptionNotificationStatusSwitch.accessibilityIdentifier = identifier(.pushSwith)
        saveButton.accessibilityIdentifier = identifier(.saveButton)
        iconChangeButton.accessibilityIdentifier = identifier(.changeButton)
      
        if let deleteButton = deleteButtonContainerView.subviews.first as? UIButton {
            deleteButton.accessibilityIdentifier = identifier(.deleteServiceButton)
        }
    }
    
    
    /**
     사용자가 선택한 색상으로 뷰의 틴트컬러를 변경합니다.
     */
    func changeTintColor() {
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor(hex: theme.sub1)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: theme.sub1)
        
        serviceNameTextField.textColor = UIColor(hex: theme.sub1)
        
        categorySegmentedControl.hideBackground()
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(hex: theme.sub1)], for: .selected)
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
        categorySegmentedControl.tintColor = UIColor(hex: theme.sub2)
        
        paymentTextField.textColor = UIColor(hex: theme.sub1)
        
        startDateSettingButton.tintColor = UIColor(hex: theme.sub1)
       
        renewalDateSettingButton.tintColor = UIColor(hex: theme.sub1)
        
        subscriptionNotificationStatusSwitch.onTintColor = UIColor(hex: theme.sub1)
        subscriptionNotificationStatusSwitch.tintColor = UIColor(hex: theme.sub2)
        
        guard savedService != nil else { return }
        
        saveButton.setTitleColor(UIColor(hex: theme.sub1), for: .normal)
        saveButtonContainerView.backgroundColor = UIColor(hex: theme.sub1)
    }
    

    /**
     saveButton의 isEnabled 속성을 true 값으로 저장하고 titleColor을 사용자가 지정한 테마 색상으로 변경합니다.
     */
    func changeButtonColor() {
        self.saveButton.isEnabled = true
        self.saveButton.setTitleColor(UIColor(hex: self.theme.sub1), for: .normal)
        
        UIView.animate(withDuration: 0.5) {
            self.saveButtonContainerView.backgroundColor = UIColor(hex: self.theme.sub1)
        }
    }
    
    
    /**
     서비스 결제일, 결제 주기를 모두 입력한 상태에서만 버튼을 활성화합니다.
     */
    func changeButtonStatus() {
        UIView.animate(withDuration: 0.35) {
            self.navigationController?.view.alpha = 0.90
        }
        
        if renewalDate != nil {
            addObserver(name: .startDateDidSelecte)
        } else if startDate != nil {
            addObserver(name: .renewalDateDidSelecte)
        }
    }
    
    
    /**
     NotificationCenter.default.addObserver를 간편하게 사용하기 위한 method입니다.
     
     사용자가 서비스를 추가, 수정 또는 삭제할 경우에만 이 method를 사용합니다. NSNotification.Name이 아래와 같은 경우에만 사용합니다.
     - addObserver(name: .startDateDidSelecte)
     - addObserver(name: .renewalDateDidSelecte)
     
     - Parameter name: Observer에게 전달하기 위해 등록 할 notification의 이름입니다.
     */
    private func addObserver(name: Notification.Name) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: .main) { _ in
            self.changeButtonColor()
        }
    }
    
    
    /**
     뒤로가기 버튼과 연결된 액션입니다.
     
     이 method가 호출되고 끝나는 시점에 *popViewController(animated:)* 가 실행됩니다.
     서비스를 수정하는 경우 모든 입력필드에 있는 속성 중 한 가지라도 변경된 값이 있을 경우 *showUpdateCaution()* 를 호출해 경고를 표시합니다.
     
     - Parameter sender: Any타입의 sender는 UIBarButtonItem 타입으로 타입캐스팅 할 수 있습니다.
     */
    @IBAction func goBack(_ sender: Any) {
        defer { navigationController?.popViewController(animated: true) }
        
        guard let serviceNameTextFieldText = serviceNameTextField.text else { return }
        guard let paymentTextFieldText = paymentTextField.text else { return }
        
        if let savedService = savedService {
            guard serviceNameTextFieldText != savedService.koreanName  ||
                  paymentTextFieldText != savedService.amountOfPayment ||
                  startDate != savedService.subscriptionStartDate      ||
                  renewalDate != savedService.subscriptionRenewalDate  ||
                  subscriptionNotificationStatusSwitch.isOn != savedService.notificationIsOn else { return }
            
            showUpdateCaution { _ in self.save(sender) }
        }
    }
    
    /**
     categorySegmentedControl와 연결된 액션입니다.
     
     categorySegmentedControl을 탭할 경우 이 method가 호출됩니다. 이 때 paymentTextField와 serviceNameTextField의 *resignFirstResponder()* 를 호출합니다.
     
     - Parameter sender: Any타입의 sender는 UISegmentedControl 타입으로 타입캐스팅 할 수 있습니다.
     */
    @IBAction func selectCategory(_ sender: Any) {
        paymentTextField.resignFirstResponder()
        serviceNameTextField.resignFirstResponder()
    }
    
    
    /**
     subscriptionNotificationStatusSwitch과 연결된 액션입니다. 결제일 하루 전 알림을 설정할 수 있습니다.
     
     이 속성의 isOn 값이 false인 경우 *removeLocalNotification(with:)* method를 호출해 연관된 서비스의 모든 Push Notification을 삭제함으로써 더 이상 알람을 보내지 않습니다.
     
     - Parameter sender: subscriptionNotificationStatusSwitch (UISwitch 타입)
     */
    @IBAction func turnOnPushAlert(_ sender: UISwitch) {
        if !(sender.isOn) {
            guard let name = serviceNameTextField.text else { return }
            
            UNUserNotificationCenter.current().removeLocalNotification(with: name)
        }
    }
    
    
    /**
     saveButton과 연결된 액션입니다. 이 버튼을 탭하여 사용자는 서비스를 추가 또는 저장(수정)할 수 있습니다.
     
     이전 화면이 ServiceListTableViewController인 경우
     - button title: "추가"
     - *CoreDataManager.shared.update()* method를 호출합니다.
     - serviceDidAdd 이름을 가진 Notification을 post합니다.
     - *dismiss(animated: completion:)* method를 호출합니다.
     
     이전 화면이 SubscriptionStatusViewController인 경우
     - button title: "저장"
     - *CoreDataManager.shared.add()* method를 호출합니다.
     - serviceDidUpdate 이름을 가진 Notification을 post합니다.
     - *popViewController(animated:)* method를 호출합니다.
     
     - Parameter sender: Any타입의 sender는 UIButton 타입으로 타입캐스팅 할 수 있습니다.
     */
    @IBAction func save(_ sender: Any) {
        guard var inputServiceName = serviceNameTextField.text,
              var inputPayment = paymentTextField.text else { return }
        
        if inputServiceName.isEmpty {
            inputServiceName = "이름없는 서비스"
        }
        
        if inputPayment.isEmpty {
            inputPayment = "0".numberFormattedString(.currency)
        }
        
        let segIndex = categorySegmentedControl.selectedSegmentIndex
        let selectedCategory = categorySegmentedControl.titleForSegment(at: segIndex) ?? "기타"
        
        if let savedService = savedService {
            coreDataManager.update(savedService,
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
            coreDataManager.add(category: selectedCategory,
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
    
    
    /**
     UIButton과 연결된 액션입니다. 이 버튼을 탭하는 경우 추가된 서비스를 삭제할 수 있습니다.
     
     이 버튼은 SubscriptionStatusViewController의 TableViewCell 을 통해 진입한 경우(사용자가 저장한 서비스를 통해 진입한 경우)에만 뷰컨트롤러에 표시됩니다.
     *showDeleteCaution(serviceName:)* 을 호출해 삭제 확인을 하고 이 method의 @escaping closure block이 실행됩니다.
     
     - Parameter sender: Any타입의 sender는 UIButton 타입으로 타입캐스팅 할 수 있습니다.
     */
    @IBAction func deleteSavedData(_ sender: Any) {
        guard let savedServiceName = savedService?.koreanName else { return }
        
        showDeleteCaution(serviceName: savedServiceName) { _ in
            self.coreDataManager.delete(self.savedService)
            NotificationCenter.default.post(name: .serviceDidDelete, object: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let startDateSettingViewController = segue.destination as? StartDateSettingViewController {
            startDateSettingViewController.delegate = self
            startDateSettingViewController.startDate = self.startDate
            changeButtonStatus()
        } else if let renewalDateSettingViewController = segue.destination as? RenewalDateSettingViewController {
            renewalDateSettingViewController.delegate = self
            changeButtonStatus()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setGestureRecognizer()
        setAccessibilityIdentifier()
        
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
            
            if let imageURLString = savedService.imageURLString, imageURLString.count < 1 {
                DispatchQueue.main.async {
                    self.serviceImageView.image = UIImage(named: "DefaultImage")
                }
            }
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
        
        setSavedDate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        changeTintColor()
        
        // IconChangeViewController의 IconChangeCollectionViewCell이 선택되면 imageDidSelecte 이름을 가진 Notification을 post합니다.
        NotificationCenter.default.addObserver(forName: .imageDidSelecte, object: nil, queue: .main) { (notification) in
            if let imageURLString = notification.userInfo?["imageURLString"] as? String {
                imageURLString.getImage { self.serviceImageView.image = UIImage(data: $0) }
                self.selectedImageURLString = imageURLString
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        paymentTextField.resignFirstResponder()
        serviceNameTextField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5
    }
    
}



// MARK:- UIGestureRecognizerDelegate
extension AddServiceTableViewController: UIGestureRecognizerDelegate {
    
    
    func setGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    
    /**
     입력 컨트롤(키보드 등)이 활성화 되어있을 때 화면을 탭하면 키보드 활성을 해제하는 method입니다.
      
     serviceNameTextField 또는 paymentTextField가 FirstResponder인 경우 *resignFirstResponder()* 를 호출합니다.
     
     - Parameter sender: UITapGestureRecognizer 타입
     */
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        guard serviceNameTextField.isFirstResponder || paymentTextField.isFirstResponder else { return }

        serviceNameTextField.resignFirstResponder()
        paymentTextField.resignFirstResponder()
    }
    
}



// MARK:- UITextFieldDelegate
extension AddServiceTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == paymentTextField else { return true }
       
        guard let nsString = textField.text as NSString? else { return true }
        
        let finalString = nsString.replacingCharacters(in: range, with: string)
        
        if finalString.count >= 12 {
            textField.textColor = .systemRed
            
            return false
            
        } else {
            textField.textColor = UIColor(hex: theme.sub1)
        }
        
        textField.text = finalString.numberFormattedString(.currency)
        
        return false
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
}



// MARK:- DateSettingViewControllerDelegate
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
    
    
    func setSavedDate() {
        guard let savedStartDate = savedService?.subscriptionStartDate else { return }
       
        startDate = savedStartDate
        startDateSettingButton.setTitle(savedStartDate.formattedString(), for: .normal)

        guard let savedRenewalDate = savedService?.subscriptionRenewalDate else { return }
        
        renewalDate = savedRenewalDate
        renewalDateSettingButton.setTitle(savedRenewalDate, for: .normal)
    }
    
    
}

