//
//  SubscriptionStatusViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit
import WidgetKit


/**
 구독 기입장의 홈화면(첫번째 탭)입니다.
 
 사용자가 추가한 서비스를 관리하거나 서비스를 추가하기 위한 뷰 컨트롤러입니다.
 */
class SubscriptionStatusViewController: UIViewController {
    
    
    /**
     SubscriptionStatusViewController 상단에 위치한 백그라운드뷰입니다.
     */
    @IBOutlet weak var customBarContainerView: UIView!
    
    
    /**
     totalAmountOfPaymentLabel 아래, 밑줄을 표시하기 위한 UIView입니다.
     */
    @IBOutlet weak var underlineView: UIView!
    
    
    /**
     사용자가 추가한 서비스 리스트를 배열로 리턴합니다.
     
     이 속성은 배열을 정렬하기 위해 사용됩니다.
     */
    lazy var sortedServices: [SavedServiceEntity] = { return CoreDataManager.shared.list }()
    
    
    /**
     사용자가 추가한 서비스를 정렬하기 위한 UIButton입니다.
     
     이 버튼을 탭하는 경우 *sortServices(_:)* 가 호출되고 뷰 컨트롤러에 액션시트가 표시됩니다.
     */
    @IBOutlet weak var sortButton: UIButton!
    
    
    /**
     ServiceListTableViewController로 이동하기 위한 UIButton입니다.
     
     이 버튼을 탭하는 경우 *prepare(for:sender:)* 가 호출되고 sender로 servicePlusButton이 전달됩니다.
     */
    @IBOutlet weak var servicePlusButton: UIButton!
    
    
    /**
     사용자가 추가한 서비스를 표시하기 위한 UITableView입니다.
     
     이 테이블뷰는 *CoreDataManager.shared.list*로부터 데이터를 가져와 테이블뷰에 표시합니다.
     - *CoreDataManager.shared.list* 는 SavedServiceEntity 타입의 배열입니다.
     - *CoreDataManager.shared.list*가 비어있는 경우, *presentDefaultLabel()* 가 호출되고 defaultSubscriptionStatusLabel을 테이블뷰에 표시합니다.
     - *CoreDataManager.shared.list* 배열의 요소가 1개 이상 인 경우, SubscriptionStatusTableViewCell을 통해 테이블뷰에 표시합니다.
     */
    @IBOutlet weak var subscriptionStatusTableView: UITableView!
    
    
    /**
     사용자가 추가한 서비스의 합산된 예상 결제 금액을 표시하기 위한 UILabel입니다.
     
     total 속성에서 초기화됩니다.
     */
    @IBOutlet weak var totalAmountOfPaymentLabel: UILabel!
    
    
    /**
     사용자가 추가한 서비스의 총 결제금액을 totalAmountOfPaymentLabel에 표시합니다.
     
     사용자가 추가한 서비스의 모든 결제금액을 합산한 결과를 리턴하고 totalAmountOfPaymentLabel.text에 표시합니다.
     */
    var total: Int = 0 {
        didSet {
            total = CoreDataManager.shared.total
            
            let animation = CATransition()
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.push
            
            totalAmountOfPaymentLabel.layer.add(animation, forKey: CATransitionType.push.rawValue)
            totalAmountOfPaymentLabel.text = String(total).numberFormattedString(.decimal) + "원"
        }
    }
    
    
    /**
     사용자가 추가한 서비스가 없을 경우  subscriptionStatusTableView에 표시하기 위한 UILabel입니다.
     
     defaultSubscriptionStatusLabel는 아래와 같은 속성을 가지고 있습니다.
     - numberOfLines = .zero
     - textAlignment = .center
     - alpha = 0
     - isHidden = true
     - text = "구독중인\n서비스를 추가해주세요."
     - font = .preferredFont(forTextStyle: .body)
     - adjustsFontForContentSizeCategory = true
     
     *addDefaultLabel()* method에서 subscriptionStatusTableView를 기준으로 제약을 추가하고, viewDidLoad()가 호출될 때 이 method를 호출합니다.  isHidden 속성은 true입니다. 이 속성을 화면에 표시하려는 경우, alpha값과 isHidden 속성을 변경해야 합니다.
     */
    var defaultSubscriptionStatusLabel: UILabel = {
        let defaultLabel = UILabel()
        defaultLabel.translatesAutoresizingMaskIntoConstraints = false
        defaultLabel.numberOfLines = .zero
        defaultLabel.textAlignment = .center
        defaultLabel.alpha = 0
        defaultLabel.isHidden = true
        defaultLabel.text = "구독중인\n서비스를 추가해주세요."
        defaultLabel.font = .preferredFont(forTextStyle: .body)
        defaultLabel.adjustsFontForContentSizeCategory = true
        
        return defaultLabel
    }()
    
    
    /**
     defaultSubscriptionStatusLabel에 subscriptionStatusTableView를 기준으로 제약을 추가합니다.
     
     *viewDidLoad()* 에서 한 번만 호출합니다.
     */
    private func addDefaultLabel() {
        view.addSubview(defaultSubscriptionStatusLabel)
        
        subscriptionStatusTableView.contentInset.top = 56
        
        defaultSubscriptionStatusLabel.centerXAnchor.constraint(equalTo: subscriptionStatusTableView.centerXAnchor).isActive = true
        defaultSubscriptionStatusLabel.centerYAnchor.constraint(equalTo: subscriptionStatusTableView.centerYAnchor).isActive = true
        defaultSubscriptionStatusLabel.leadingAnchor.constraint(lessThanOrEqualTo: subscriptionStatusTableView.leadingAnchor, constant: 20).isActive = true
        defaultSubscriptionStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: subscriptionStatusTableView.trailingAnchor, constant: 20).isActive = true
        
        defaultSubscriptionStatusLabel.bringSubviewToFront(view)
    }
    
    
    /**
     defaultSubscriptionStatusLabel 표시 여부를 결정하는 method입니다.
     
     *CoreDataManager.shared.list* 배열이 비어있는지 여부에 따라 표시 여부가 결정됩니다.
     - 배열이 비어있는 경우 defaultSubscriptionStatusLabel의 alpha와 isHidden 속성을 각각 0.3, false로 변경(표시)합니다.
     - 배열의 요소가 1개 이상인 경우 defaultSubscriptionStatusLabel의 alpha와 isHidden 속성을 각각 0.0, true로 변경(숨김)합니다.
     */
    private func presentDefaultLabel() {
        UIView.animate(withDuration: 0.5, delay: .zero) {
            let serviceIsEmpty = CoreDataManager.shared.list.isEmpty
            self.defaultSubscriptionStatusLabel.alpha = serviceIsEmpty ? 0.3 : 0.0
            self.defaultSubscriptionStatusLabel.isHidden = serviceIsEmpty ? false : true
        }
    }
    
    /**
     사용자가 선택한 색상으로 뷰의 틴트컬러를 변경합니다.
     
     사용자가 선택한 색상의 index는 UserDefaults.standard.integer(forKey: "selectedIndex")에 저장되어 있습니다.
     CustomColor.shared.themes 배열에서 이 index값으로 사용자가 선택한 색상을 가져올 수 있습니다.
     */
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let theme = CustomColor.shared.themes[index]
        
        UIApplication.shared.windows.first?.tintColor = UIColor(rgb: theme.main)
        sortButton.tintColor = UIColor(rgb: theme.main)
        servicePlusButton.tintColor = UIColor(rgb: theme.main)
        self.tabBarController?.tabBar.tintColor = UIColor(rgb: theme.main)
        underlineView.backgroundColor = UIColor(rgb: theme.sub2)
    }
    
    
    /**
     NotificationCenter.default.addObserver를 간편하게 사용하기 위한 method입니다.
     
     사용자가 서비스를 추가, 수정 또는 삭제할 경우에만 이 method를 사용합니다. NSNotification.Name이 아래와 같은 경우에만 사용합니다.
     - addObserver(name: .serviceDidAdd)
     - addObserver(name: .serviceDidDelete)
     - addObserver(name: .serviceDidUpdate)
     
     이 메소드가 호출되면 사용자가 추가한 서비스의 총 결제금액을 다시 계산한 다음 저장하고, subscriptionStatusTableView.reloadData(), presentDefaultLabel()가 순서대로 호출됩니다.
     
     - Parameter name: Observer에게 전달하기 위해 등록 할 notification의 이름입니다.
     - Parameter queue: 코드가 실행될 OperationQueue를 전달합니다.
     */
    func addObserver(name: NSNotification.Name, queue: OperationQueue = .main) {
        NotificationCenter.default.addObserver(forName: name, object: nil, queue: queue) { _ in
            self.total = CoreDataManager.shared.total
            
            self.subscriptionStatusTableView.reloadData()
            
            self.presentDefaultLabel()
            
            guard name == .serviceDidAdd || name == .serviceDidUpdate else { return }
            
            for service in CoreDataManager.shared.list {
                if service.notificationIsOn {
                    UNUserNotificationCenter.current().addLocalNotification(service: service)
                }
            }
        }
    }
    
    
    /**
     이 버튼을 탭하는 경우 사용자가 정렬방법을 선택할 수 있습니다.
     
     화면에 표시되는 액션시트는 *showSortActionSheet()* method를 통해 세 가지 액션을 제공합니다. 각각 서비스의 이름, 결제금액, 결제일 순서대로 정렬할 수 있습니다.
     - Parameter sender: sender로  sortButton(UIButton 타입)이 전달되며, IBOutlet으로 연결되어 있습니다.
     */
    @IBAction func sortServices(_ sender: UIButton) {
        
        showSortActionSheet(sender) { action in
            sender.setTitle((action.title ?? "")+" ▼", for: .normal)
            
            CoreDataManager.shared.list.sort {
                switch action.title {
                case "이름순":
                    return $0.koreanName ?? "" < $1.koreanName ?? ""
                    
                case "결제금액순":
                    let valueA = Int($0.amountOfPayment?.numberFormattedString(.none) ?? "") ?? 0
                    let valueB = Int($1.amountOfPayment?.numberFormattedString(.none) ?? "") ?? 0
                    
                    return valueA > valueB
                    
                case "결제일순":
                    return $0.nextPaymentDate ?? Date() < $1.nextPaymentDate ?? Date()
                    
                default:
                    return false
                }
            }
            self.subscriptionStatusTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CoreDataManager.shared.fetch()
        
        for service in CoreDataManager.shared.list {
            if service.notificationIsOn {
                UNUserNotificationCenter.current().addLocalNotification(service: service)
            }
        }
        
        total = CoreDataManager.shared.total
        
        addDefaultLabel()
        presentDefaultLabel()
        
        addObserver(name: .serviceDidAdd)
        addObserver(name: .serviceDidDelete)
        addObserver(name: .serviceDidUpdate)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tempServiceTVC = segue.destination as? AddServiceTableViewController else { return }
        
        if let cell = sender as? SubscriptionStatusTableViewCell, let indexPath = subscriptionStatusTableView.indexPath(for: cell) {
            let savedService = CoreDataManager.shared.list[indexPath.row]
            
            tempServiceTVC.savedService = savedService
            
            savedService.imageURLString?.getImage { tempServiceTVC.selectedImage = UIImage(data: $0) }
            tempServiceTVC.selectedImageURLString = savedService.imageURLString
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTintColor()
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        guard !(CoreDataManager.shared.list.isEmpty) else { return }
        
        for i in 0..<CoreDataManager.shared.list.count {
            CoreDataManager.shared.list[i].nextPaymentDate = CoreDataManager.shared.list[i].subscriptionStartDate?
                .calculatingPaymentDays(CoreDataManager.shared.list[i].subscriptionRenewalDate ?? "1개월").first
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // sortButton title속성을 정렬 방법으로 변경합니다.
        sortButton.setTitle("정렬방법 ▼", for: .normal)
        
        // 데이터 정렬 방법을 생성날짜(default)로 변경합니다.
        CoreDataManager.shared.list.sort { $0.createdDate ?? Date() < $1.createdDate ?? Date() }
        
        self.subscriptionStatusTableView.reloadData()
    }
    
    
}



// MARK:- TableView DataSource
extension SubscriptionStatusViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubscriptionStatusTableViewCell.identifier, for: indexPath) as? SubscriptionStatusTableViewCell else {
            #if DEBUG
            fatalError()
            #else
            return UITableViewCell()
            #endif
        }
        
        let coreManager = CoreDataManager.shared.list[indexPath.row]
        cell.serviceNameLabel.text = coreManager.koreanName
        cell.paymentLabel.text = coreManager.amountOfPayment
        
        // CoreData에 imageURLString이 저장되어 있으나 URL의 길이가 1 미만이라면 정상적인 URL이 아니므로 이 땐, cell.logoImageView.image에 Default Image를 생성해 저장합니다.
        if let imageURLString = coreManager.imageURLString, imageURLString.count < 1 {
            cell.logoImageView.image = UIImage(named: "DefaultImage")
        } else if let _ = coreManager.imageURLString  {
            coreManager.imageURLString?.getImage { cell.logoImageView.image = UIImage(data: $0) }
        }
        
        return cell
    }
    
    
}



// MARK:- TableView Deletage
extension SubscriptionStatusViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let serviceName = CoreDataManager.shared.list[indexPath.row].koreanName {
            
            let indexPathRow = indexPath.row
            let action = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
                self.showDeleteCaution(serviceName: serviceName) { _ in
                    UNUserNotificationCenter.current().removeLocalNotification(with: serviceName)
                    CoreDataManager.shared.delete(at: indexPathRow)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.total = CoreDataManager.shared.total
                    
                    self.presentDefaultLabel()
                }
                
                completion(false)
            }
            
            if #available(iOS 13.0, *) {
                action.backgroundColor = UIColor(named: "Custom Background Color")
            } else {
                action.backgroundColor = .red
            }
            
            action.image = UIImage(named: "DeleteIcon")
            
            let configuration = UISwipeActionsConfiguration(actions: [action])
            configuration.performsFirstActionWithFullSwipe = false
            
            return configuration
        }
        
        return nil
    }
    
    
}
