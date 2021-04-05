//
//  IconChangeViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit


/**
 AddServiceTableViewController의 serviceImageView 이미지 변경을 돕는 뷰 컨트롤러입니다.
 */
class IconChangeViewController: UIViewController {
    
    
    /**
     서버로부터 가져온 아이콘 이미지를 순서대로 보여주기 위한 UICollectionView입니다.
     */
    @IBOutlet weak var iconChangeCollectionView: UICollectionView!
    
    
    /**
     서버로부터 가져온 서비스 목록 리스트를 *joined()* method를 통해 1차원 배열로 변경합니다.
     */
    var services: [Service] { Array(ServiceApiManager.shared.services.joined()) }
   
    
    /**
     Gray Style의 UIActivityIndicatiorView입니다.
     */
    var spinner = UIActivityIndicatorView(style: .gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if services.isEmpty {
            spinner.center = self.iconChangeCollectionView.center
            spinner.startAnimating()
            
            view.addSubview(spinner)
            
            ServiceApiManager.shared.requestServices { [self] in
                spinner.stopAnimating()
                
                iconChangeCollectionView.reloadData()
            }
        }
    }
    
    
}



// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension IconChangeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconChangeCollectionViewCell.identifier, for: indexPath) as! IconChangeCollectionViewCell
        
        services[indexPath.item].getImage { (data, _) in
            cell.iconImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ = collectionView.cellForItem(at: indexPath) as! IconChangeCollectionViewCell
     
        services[indexPath.item].getImage { (_, imageURLString) in
            
            /**
             imageURLString 키와 값을 가진 딕셔너리를 userInfo에 저장합니다.
             
             IconChangeCollectionViewCell이 선택되면 *post(name:objec:userInfo:)* 의 userInfo 파라미터에 이 userInfo를 전달합니다.
             */
            let userInfo = ["imageURLString": imageURLString]
            
            // AddServiceTableViewController의 viewWillAppear method에서 imageDidSelecte 이름을 가진 Notification을 Observe합니다.
            NotificationCenter.default.post(name: .imageDidSelecte, object: nil, userInfo: userInfo as [AnyHashable : Any])
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}



// MARK: - UICollectionViewDelegateFlowLayout
extension IconChangeViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // MARK: 정사각형 Cell Size
        //
        // 1. collectionView의 minimumInteritemSpacing 속성에 접근하기 위해 collectionViewLayout 파라미터를 UICollectionViewFlowLayout 타입으로 타입캐스팅을 합니다.
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        
        
        // 2. 한 줄에 표시하고 싶은 Cell의 갯수를 저장합니다.
        let numberOfCells: CGFloat = 3
        
        
        // 3. width값을 계산합니다. 이 때 minimumInteritemSpacing 값 등 여백을 없앤 값을 저장합니다.
        let width = collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells-1))
        
        return CGSize(width: width/(numberOfCells), height: width/(numberOfCells))
    }
    
    
}
