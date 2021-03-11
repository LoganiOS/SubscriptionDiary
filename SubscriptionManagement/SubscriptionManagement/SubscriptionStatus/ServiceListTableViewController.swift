
import UIKit
import Moya

class ServiceListTableViewController: UITableViewController {
    let spinner = UIActivityIndicatorView(style: .gray)
    var filteredServices = [Service]()
    var services: [Service] { Array(ServiceApiManager.shared.services.joined()) }
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarIsEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    var searchBarIsFiltering: Bool { return searchController.isActive && !searchBarIsEmpty }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredServices = ServiceApiManager.shared.services
            .flatMap{ $0 }.filter {
                $0.koreanName.components(separatedBy: " ").joined().contains(searchText) ||
                    $0.englishName.lowercased().components(separatedBy: " ").joined()
                    .contains(searchText.lowercased())
            }
        tableView.reloadData()
    }
    
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(rgb: CustomColor.shared.themes[index].main)
        self.navigationItem.leftBarButtonItem?.tintColor = customTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = customTintColor
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if services.isEmpty {
            tableView.backgroundView = spinner
            spinner.startAnimating()
            ServiceApiManager.shared.requestServices {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "구독중인 서비스를 검색해보세요."
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        changeTintColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            guard let cell = cell as? ServiceListTableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            guard let addServiceTableViewController = segue.destination as? AddServiceTableViewController else { return }
            
            let service: Service = searchBarIsFiltering ? filteredServices[indexPath.row] : ServiceApiManager.shared.services[indexPath.section][indexPath.row]
            addServiceTableViewController.selectedCategory = service.category.name
            addServiceTableViewController.serviceNameText = service.koreanName
            addServiceTableViewController.serviceEnglishNameText = service.englishName
            service.getImage { (data, URLString) in
                addServiceTableViewController.selectedImage = UIImage(data: data)
                addServiceTableViewController.selectedImageURLString = URLString
            }
            
        } else if let _ = sender as? UIBarButtonItem {
            guard let addServiceTableViewController = segue.destination as? AddServiceTableViewController else { return }
            addServiceTableViewController.serviceNameText = ""
            addServiceTableViewController.selectedImage = UIImage(named: "DefaultImage")
        }
    }
    
    // MARK:- Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        if spinner.isAnimating { return 0 }
        if searchBarIsFiltering { return 1 }
        return ServiceApiManager.shared.services.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsFiltering { return filteredServices.count }
        return ServiceApiManager.shared.services[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBarIsFiltering { return "Searched" }
        switch section {
        case 0:
            return "OTT"
        case 1:
            return "음악"
        case 2:
            return "사무"
        default:
            return "기타"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceListTableViewCell", for: indexPath) as? ServiceListTableViewCell else { return UITableViewCell() }
        if searchBarIsFiltering {
            cell.serviceName.text = filteredServices[indexPath.row].koreanName
            filteredServices[indexPath.row].getImage { (data, _) in
                cell.logoImage.image = UIImage(data: data)
            }
        } else {
            cell.serviceName.text = ServiceApiManager.shared.services[indexPath.section][indexPath.row].koreanName
            ServiceApiManager.shared.services[indexPath.section][indexPath.row].getImage { (data, _) in
                cell.logoImage.image = UIImage(data: data)
            }
        }
        return cell
    }
}


extension ServiceListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedKeyword = searchController.searchBar.text else { return }
        filterContentForSearchText(searchedKeyword.components(separatedBy: " ").joined())
    }
}


