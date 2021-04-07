//
//  ServiceApiManager.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/01.
//

import UIKit
import Moya
import RxSwift
import RxCocoa


/**
 싱글톤 패턴의 class입니다. shared 속성에 한 번만 메모리를 할당하고 이 메모리에 객체를 만들어 사용합니다.
 */
class ServiceApiManager {
    
    /**
     ServiceApiManager 타입의 속성입니다.
     */
    static let shared = ServiceApiManager()
   
    
    private init() { }
    
    
    /**
     Request provider class입니다. request는 반드시 이 속성으로만 호출해야합니다.
     */
    let provider = MoyaProvider<ServiceProvider>()
    
    
    /**
     deinit() 시점에 이 속성에 추가된 모든 disposibles 속성의 구독이 해제됩니다.
     */
    let bag = DisposeBag()
    
    
    /**
     서버로부터 파싱한 데이터를 이 배열에 저장합니다.
     
     이 배열은 2차원 배열입니다.
     */
    var services = [[Service](), [Service](), [Service](), [Service]()]
       
    
    /**
     서버로부터 서비스 목록을 요청하는 method입니다.
     
     요청이 정상적으로 이루어지면 self.services에 파싱된 데이터를 저장합니다.
     실패할 경우 error가 출력됩니다.
     
     - parameter completion: 요청이 정상적으로 진 후에 진행해야 할 작업을 이 코드블럭에서 코드를 구현합니다.
     */
    func requestServices(_ completion: @escaping () -> ()) {
        provider.rx.request(ServiceProvider.services)
            .map([Service].self)
            .subscribe { result in
                switch result {
                case .success(let response):
                    for i in 0...3 {
                        self.services[i] = response
                            .filter { $0.category.id == i + 1 }
                    }
                    completion()
                case .error(let error) :
                    print(error)
                }
            }
            .disposed(by: bag)
    }
    
}
