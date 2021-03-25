//
//  ServiceListTableViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit
import Moya

class ServiceListTableViewController: UITableViewController {
    
    let spinner = UIActivityIndicatorView(style: .gray)
    
    /// 서비스목록을 필터링할 때 사용할 서비스 목록입니다.
    var filteredServices = [Service]()
    
    /// 서버로부터 가져온 서비스 목록 리스트를 1차원 배열로 리턴합니다.
    var services: [Service] { Array(ServiceApiManager.shared.services.joined()) }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    /// searchController.searchBar.text?.isEmpty 속성이 true인 경우 true를 리턴합니다.
    var searchBarIsEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    
    /// 서치컨트롤러가 활성중이면서 searchBarIsEmpty 속성이 false인 경우에 true를 리턴합니다.
    var searchBarIsFiltering: Bool { return searchController.isActive && !searchBarIsEmpty }
    
    
    /// 검색어를 필터링합니다. 띄어쓰기를 무시하고, 한국어, 영어 이름(대소문자 무시)과 일치하는 모든 서비스를 필터링한 다음, 테이블뷰를 리로드합니다.
    /// - Parameter searchText: 서치바에 입력할 텍스트입니다.
    func filterContentForSearchText(_ searchText: String) {
            filteredServices = ServiceApiManager.shared.services
                .flatMap{ $0 }
                .filter {
            $0.koreanName
                .components(separatedBy: " ")
                .joined()
                .contains(searchText)
         || $0.englishName
                .lowercased()
                .components(separatedBy: " ")
                .joined()
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
        
        changeTintColor()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            guard let cell = cell as? ServiceListTableViewCell, let indexPath = tableView.indexPath(for: cell) else { return }
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
        if spinner.isAnimating {
            return 0
        }
        
        if searchBarIsFiltering {
            return 1
        }
        
        return ServiceApiManager.shared.services.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsFiltering {
            return filteredServices.count
        }
        
        return ServiceApiManager.shared.services[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBarIsFiltering {
            return "Searched"
        }
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ServiceListTableViewCell.identifier, for: indexPath) as! ServiceListTableViewCell
       
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



// MARK:- UISearchResultsUpdating
extension ServiceListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchedKeyword = searchController.searchBar.text else { return }
        
        filterContentForSearchText(searchedKeyword.components(separatedBy: " ").joined())
    }
}
