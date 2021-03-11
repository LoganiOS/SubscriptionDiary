

import UIKit
import WidgetKit

class SubscriptionStatusViewController: UIViewController {
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var customBarContainerView: UIView!
    @IBOutlet weak var servicePlusButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var subscriptionStatusTableView: UITableView!
    @IBOutlet weak var totalAmountOfPaymentLabel: UILabel!
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
    
    lazy var sortedServices: [SavedServiceEntity] = {
        return CoreDataManager.shared.list
    }()
    
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
    
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let theme = CustomColor.shared.themes[index]
        UIApplication.shared.windows.first?.tintColor = UIColor(rgb: theme.main)
        sortButton.tintColor = UIColor(rgb: theme.main)
        servicePlusButton.tintColor = UIColor(rgb: theme.main)
        self.tabBarController?.tabBar.tintColor = UIColor(rgb: theme.main)
        
        underlineView.backgroundColor = UIColor(rgb: theme.sub2)
    }
    
    
    @IBAction func sortServices(_ sender: UIButton) {
        showSortActionSheet {
            sender.setTitle(($0.title ?? "")+" ▼", for: .normal)
            CoreDataManager.shared.list
                .sort { $0.koreanName ?? "" < $1.koreanName ?? ""
            }
            self.subscriptionStatusTableView.reloadData()                  
        }
        
        sortByPrice: {
            sender.setTitle(($0.title ?? "")+" ▼", for: .normal)
            CoreDataManager.shared.list
                .sort { Int($0.amountOfPayment?.numberFormattedString(.none) ?? "") ?? 0 > Int($1.amountOfPayment?.numberFormattedString(.none) ?? "") ?? 0 }
            self.subscriptionStatusTableView.reloadData()
        }
        
        sortByDate: {
            sender.setTitle(($0.title ?? "")+" ▼", for: .normal)
            CoreDataManager.shared.list
                .sort { $0.nextPaymentDate ?? Date() < $1.nextPaymentDate ?? Date()
            }
            self.subscriptionStatusTableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        changeTintColor()
        
        guard !(CoreDataManager.shared.list.isEmpty) else { return }
        for i in 0..<CoreDataManager.shared.list.count {
            CoreDataManager.shared.list[i].nextPaymentDate = CoreDataManager.shared.list[i].subscriptionStartDate?
                .calculatingPaymentDays(
                    CoreDataManager.shared.list[i].subscriptionRenewalDate ?? "1개월").first
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sortButton.setTitle("정렬방법 ▼", for: .normal)
        CoreDataManager.shared.list.sort { $0.createdDate ?? Date() < $1.createdDate ?? Date() }
        self.subscriptionStatusTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CoreDataManager.shared.fetch()
        for service in CoreDataManager.shared.list {
            if service.notificationIsOn {
                UNUserNotificationCenter.current().addLocalNotification(service: service)
            }
        }
        
        view.addSubview(defaultSubscriptionStatusLabel)
        subscriptionStatusTableView.contentInset.top = 56
        defaultSubscriptionStatusLabel.centerXAnchor.constraint(equalTo: subscriptionStatusTableView.centerXAnchor).isActive = true
        defaultSubscriptionStatusLabel.centerYAnchor.constraint(equalTo: subscriptionStatusTableView.centerYAnchor).isActive = true
        defaultSubscriptionStatusLabel.leadingAnchor.constraint(lessThanOrEqualTo: subscriptionStatusTableView.leadingAnchor, constant: 20).isActive = true
        defaultSubscriptionStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: subscriptionStatusTableView.trailingAnchor, constant: 20).isActive = true
        defaultSubscriptionStatusLabel.bringSubviewToFront(view)
        
        total = CoreDataManager.shared.total
        presentDefaultLabel()
        
        addObserver(name: .serviceDidAdd)
        addObserver(name: .serviceDidDelete)
        addObserver(name: .serviceDidUpdate)
        
    }
    
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
    
    func presentDefaultLabel() {
        UIView.animate(withDuration: 0.5, delay: .zero) {
            if CoreDataManager.shared.list.count == 0 {
                self.defaultSubscriptionStatusLabel.alpha = 0.3
                self.defaultSubscriptionStatusLabel.isHidden = false
            } else {
                self.defaultSubscriptionStatusLabel.alpha = 0.0
                self.defaultSubscriptionStatusLabel.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let tempServiceTVC = segue.destination as? AddServiceTableViewController else { return }
        if let cell = sender as? SubscriptionStatusTableViewCell, let indexPath = subscriptionStatusTableView.indexPath(for: cell) {
            tempServiceTVC.savedService = CoreDataManager.shared.list[indexPath.row]
            CoreDataManager.shared.list[indexPath.row].imageURLString?.getImage { tempServiceTVC.selectedImage = UIImage(data: $0) }
            tempServiceTVC.selectedImageURLString = CoreDataManager.shared.list[indexPath.row].imageURLString
        }
    }
}

extension SubscriptionStatusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.shared.list.isEmpty ? 0 : CoreDataManager.shared.list.count
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
        coreManager.imageURLString?.getImage { cell.logoImageView.image = UIImage(data: $0) }

        return cell
    }
}

extension SubscriptionStatusViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let serviceName = CoreDataManager.shared.list[indexPath.row].koreanName else { return UISwipeActionsConfiguration() }
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
        
        if #available(iOS 13.0, *) { action.backgroundColor = UIColor(named: "Custom Background Color") }
        else { action.backgroundColor = .red }
        action.image = UIImage(named: "DeleteIcon")
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
    }
}


