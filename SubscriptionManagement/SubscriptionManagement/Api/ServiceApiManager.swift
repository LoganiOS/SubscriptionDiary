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

class ServiceApiManager {
    static let shared = ServiceApiManager()
    private init() { }
    
    let provider = MoyaProvider<ServiceProvider>()
    let bag = DisposeBag()
    
    var services = [[Service](), [Service](), [Service](), [Service]()]
        
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
