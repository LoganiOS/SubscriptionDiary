//
//  UIViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit

extension UIViewController {
    
    func showDeleteCaution(serviceName: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: "'\(serviceName)'서비스를\n 구독 리스트에서 지우시겠어요?\n삭제된 내용은 복구할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: handler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showUpdateCaution(handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "변경", message: "변경사항을 저장하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: handler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCaution(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSortActionSheet(_ sender: UIButton, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "이름순", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "결제금액순", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "결제일순", style: .default, handler: handler))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alert.popoverPresentationController {
                let bounds = sender.bounds
                let rect = CGRect(x: bounds.maxX - 20, y: bounds.maxY,
                                  width: bounds.width, height: bounds.height)
                
                popoverController.sourceView = self.view
                popoverController.sourceRect = rect
                
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            self.present(alert, animated: true, completion: nil)
        }
        
        alert.view.subviews
            .flatMap { $0.constraints }
            .filter { $0.constant < 0 }
            .first?.isActive = false
    }
    
}
