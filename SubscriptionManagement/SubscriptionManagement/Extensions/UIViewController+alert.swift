

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
    
    
    /// 버튼을 누를 경우 정렬방법을 위한 action sheet를 표시합니다.
    /// - Parameters: 
    ///   - sender: 이벤트를 발생 시킬 sender (UIButton)
    ///   - sortByName: 이름순으로 정렬할 경우 실행하고 싶은 코드를 클로저로 전달합니다.
    ///   - sortByPrice: 결제금액순으로 정렬할 경우 실행하고 싶은 코드를 클로저로 전달합니다.
    ///   - sortByDate: 결제일순으로 정렬할 경우 실행하고 싶은 코드를 클로저로 전달합니다.
    func showSortActionSheet(_ sender: UIButton, sortByName: ((UIAlertAction) -> Void)? = nil, sortByPrice: ((UIAlertAction) -> Void)? = nil, sortByDate: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "이름순", style: .default, handler: sortByName))
        alert.addAction(UIAlertAction(title: "결제금액순", style: .default, handler: sortByPrice))
        alert.addAction(UIAlertAction(title: "결제일순", style: .default, handler: sortByDate))
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
            .filter { ($0.constant < 0) }
            .first?.isActive = false
    }
}
