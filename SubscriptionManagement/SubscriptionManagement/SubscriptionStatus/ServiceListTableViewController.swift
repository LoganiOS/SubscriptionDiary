//
//  ServiceListTableViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit
import Moya


/**
 서비스 목록을 보여주는 테이블 뷰 컨트롤러입니다.
 
 서버로부터 데이터를 가져오며, 데이터를 가져오는 동안 UIActivityIndicatorView 애니메이션이 실행됩니다.
 데이터를 불러오면 UIActivityIndicatorView의 애니메이션이 중지되고  모든 서비스 목록을 테이블뷰에 표시합니다.
 */
class ServiceListTableViewController: UITableViewController {
    
    
    /**
     Gray Style의 UIActivityIndicatiorView입니다.
     */
    let spinner = UIActivityIndicatorView(style: .gray)
    
    
    /**
     UISearchController에 사용 할 서비스 목록입니다.
     */
    var filteredServices = [Service]()
    
    
    /**
     서버로부터 가져온 서비스 목록 리스트를 *joined()* method를 통해 1차원 배열로 변경합니다.
     */
    var services: [Service] { Array(ServiceApiManager.shared.services.joined()) }
    
    
    /**
     UISearchController 인스턴스를 생성합니다.
     
     UISearchController(searchResultsController:) 생성자를 통해 인스턴스를 생성할 때, searchResultsController에 SearchController를 표시 할 뷰 컨트롤러를 전달합니다. 현재 뷰 컨트롤러에 표시 하기 때문에 searchResultsController값을 nil로 설정합니다.
     */
    let searchController = UISearchController(searchResultsController: nil)
    
    
    /**
     사용자가 선택한 색상으로 뷰의 틴트컬러를 변경합니다.
     
     사용자가 선택한 색상의 index는 UserDefaults.standard.integer(forKey: "selectedIndex")에 저장되어 있습니다.
     CustomColor.shared.themes 배열에서 이 index값으로 사용자가 선택한 색상을 가져올 수 있습니다.
     */
    func changeTintColor() {
        let index = UserDefaults.standard.integer(forKey: "selectedIndex")
        let customTintColor = UIColor(hex: CustomColor.shared.themes[index].main)
        
        self.navigationItem.leftBarButtonItem?.tintColor = customTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = customTintColor
    }
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 사용자가 cell(UITableViewCell)을 탭해 화면을 이동하는 경우
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
        
        // 사용자가 직접추가 버튼(UIBarButtonItem)을 탭해 화면을 이동하는 경우
        } else if let _ = sender as? UIBarButtonItem {
            guard let addServiceTableViewController = segue.destination as? AddServiceTableViewController else { return }
            addServiceTableViewController.serviceNameText = ""
            addServiceTableViewController.selectedImage = UIImage(named: "DefaultImage")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAccessibilityIdentifier()
        
        if services.isEmpty {
            tableView.backgroundView = spinner
            spinner.startAnimating()
            ServiceApiManager.shared.requestServices {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
        
        fetchSearchController()
        changeTintColor()
    }
    
    
    
    // MARK:- Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        if spinner.isAnimating {
            return 0
        }
        
        return searchBarIsFiltering ? 1 : ServiceApiManager.shared.services.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarIsFiltering ? filteredServices.count : ServiceApiManager.shared.services[section].count
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
    
    
    /**
     searchController.searchBar.text?.isEmpty 속성이 true인 경우 true를 리턴합니다.
     */
    var searchBarIsEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    
    
    /**
     searchController.isActive 속성이 true이면서 searchBarIsEmpty 속성이 false인 경우에 true를 리턴합니다.
     */
    var searchBarIsFiltering: Bool { return searchController.isActive && !searchBarIsEmpty }
    
    
    /**
     문자열을 필터링하는 method입니다.
     
     서비스 이름 문자열을 파라미터로 전달하면 다음과 같은 조건으로 필터링합니다.
     - 띄어쓰기를 무시합니다.
     - 서비스의 한국어 이름이 일치하는 문자열을 포함합니다.
     - 서비스의 영어 이름(대소문자 무시)이 일치하는 문자열을 포함합니다.
     
     필터링 이후 tableView를 reload합니다. 이 method는 *updateSearchResults(for:)* 외의 method에서 호출하지 않습니다.
     
     - Parameter searchText: 필터링 할 문자열(String 타입)를 전달합니다.
     */
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
    
    
    /**
     searchController 사용에 필요한 초기화 작업을 진행합니다.
     
     이 method는 아래와 같은 작업을 수행합니다.
     - Delegate를 self로 지정합니다.
     - obscuresBackgroundDuringPresentation속성을 false로 저장합니다.
     - searchBar.placeholder를 "구독중인 서비스를 검색해보세요."로 저장합니다.
     - navigationItem.searchController에 searchController를 저장합니다.
     */
    func fetchSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "구독중인 서비스를 검색해보세요."
        
        navigationItem.searchController = searchController
    }
    

    func updateSearchResults(for searchController: UISearchController) {
        // 시스템은 search bar가 firstresponder로 지정되거나 serch bar의 텍스트가 변경될 때마다 method를 호출합니다. 입력된 text는 searchController.searchBar.text 속성을 통해 얻을 수 있습니다.
        guard let searchedKeyword = searchController.searchBar.text else { return }
        
        // search bar에 입력된 텍스트를 filterContentForSearchText(_:) 파라미터로 전달합니다.
        filterContentForSearchText(searchedKeyword.components(separatedBy: " ").joined())
    }
    
    
}



// MARK: - Accessiblility Identifier
extension ServiceListTableViewController {
    
    
    private func identifier(_ matchedID: AccessibilityIdentifier) -> String {
        return matchedID.rawValue
    }
    
    func setAccessibilityIdentifier() {
        navigationController?.navigationBar.accessibilityIdentifier = identifier(.serviceListTableViewNavigationBar)
        navigationItem.leftBarButtonItem?.accessibilityIdentifier = identifier(.leftBarButton)
        navigationItem.rightBarButtonItem?.accessibilityIdentifier = identifier(.rightBarButton)
    }
    
    
}
