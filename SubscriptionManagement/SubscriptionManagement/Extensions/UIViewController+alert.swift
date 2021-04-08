//
//  UIViewController.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit


extension UIViewController {
    
    /**
     사용자에게 알람을 표시하는 method입니다.
     
     이 method는 사용자가 서비스를 삭제할 때만 호출해야 합니다. 2개의 alert action을 가지고 있습니다.
     - 취소: -
     - 삭제: destructive 스타일의 액션입니다. 이 액션을 취하는 경우 이 액션의 hadler의 코드블럭이 실행됩니다.
     
     - parameter serviceName: 삭제할 서비스의 이름을 문자열로 전달합니다.
     - parameter handler: 삭제 버튼을 누를 경우 이 hadler로 전달된 코드블럭이 실행됩니다. 기본값은 nil입니다.
     */
    func showDeleteCaution(serviceName: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "", message: "'\(serviceName)'서비스를\n 구독 리스트에서 지우시겠어요?\n삭제된 내용은 복구할 수 없습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: handler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /**
     사용자에게 알람을 표시하는 method입니다.
     
     이 method는 사용자가 저장한 서비스를 수정했으나 저장하지 않았을 경우 호출합니다. 2개의 alert action을 가지고 있습니다.
     - 취소: 취소를 누르는 경우 popViewController(animated:)가 호출됩니다.
     - 저장: 저장을 누르는 경우 handler로 전달된 코드블럭이 실행됩니다.
     
     - parameter handler: 삭제 버튼을 누를 경우 이 hadler로 전달된 코드블럭이 실행됩니다. 기본값은 nil입니다.
     */
    func showUpdateCaution(handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "변경", message: "변경사항을 저장하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "저장", style: .default, handler: handler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /**
     사용자에게 알람을 표시하는 method입니다.
     
     일반적인 경고 알람을 표시할 때 이 method를 호출합니다. 1개의 action을 가지고 있습니다.
     - 확인: -
     
     - parameter message: 화면에 표시하고 싶은 문자열을 전달합니다.
     */
    func showCaution(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /**
     사용자에게 알람을 표시하는 method입니다.
     
     사용자가 저장한 서비스를 정렬해야할때만 이 method를 호출합니다. 3개의 alert action을 가지고 있습니다.
     - 이름순: 이 action의 handler에서 저장한 서비스를 이름 순서대로 정렬하는 코드를 구현합니다.
     - 결제금액순: 이 action의 handler에서 저장한 서비스를 결제금액 순서대로 정렬하는 코드를 구현합니다.
     - 결제일순: 이 action의 handler에서 저장한 서비스를 결제일 순서대로 정렬하는 코드를 구현합니다.
     
     iPad에서 이 method가 호출되는 경우 이 알람을 method를 호출한 버튼 오른쪽을 sourceView로 지정합니다.
     - parameter sender: method를 호출한 sender를 전달합니다. (UIButton Type)
     - parameter handler: 삭제 버튼을 누를 경우 이 hadler로 전달된 코드블럭이 실행됩니다. 기본값은 nil입니다.
     */
    func showSortActionSheet(_ sender: UIButton, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "이름순", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "결제금액순", style: .default, handler: handler))
        alert.addAction(UIAlertAction(title: "결제일순", style: .default, handler: handler))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        
        // iPad에서 이 method가 호출되는 경우 이 알람을 method를 호출한 버튼 오른쪽을 sourceView로 지정합니다.
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
