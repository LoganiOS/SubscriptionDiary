//
//  IconChangeViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/17.
//

import UIKit

class IconChangeViewController: UIViewController {
    
    @IBOutlet weak var iconChangeCollectionView: UICollectionView!
    var services: [Service] { Array(ServiceApiManager.shared.services.joined()) }
    
    var spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.center = self.iconChangeCollectionView.center
        self.spinner.startAnimating()
        self.view.addSubview(spinner)
        
        if self.services.isEmpty {
            ServiceApiManager.shared.requestServices { [self] in
                spinner.stopAnimating()
                iconChangeCollectionView.reloadData()
            }
        }
    }
}

extension IconChangeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconChangeCollectionViewCell", for: indexPath) as? IconChangeCollectionViewCell else { return UICollectionViewCell() }
        services[indexPath.item].getImage { (data, _) in
            cell.iconImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? IconChangeCollectionViewCell else { return }
        services[indexPath.item].getImage { (_, imageURLString) in
            let userInfo = ["imageURLString": imageURLString]
            NotificationCenter.default.post(name: .imageDidSelecte, object: nil, userInfo: userInfo as [AnyHashable : Any])
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension IconChangeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        let numberOfCells: CGFloat = 3
        let width = collectionView.frame.size.width - (flowLayout.minimumInteritemSpacing * (numberOfCells-1))
        return CGSize(width: width/(numberOfCells), height: width/(numberOfCells))
    }
    
}
