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

public let host = "https://subscriptiondiary.azurewebsites.net"

private enum ApiError: Error {
    case invalidUrl
    case failed(Int)
    case emptyData
}

private enum HttpMethod: String {
    case GET
}

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

// MARK:- 사용안함
//extension ServiceApiManager {
//    func get(with id: Int? = nil, _ completion: @escaping () -> ()) {
//        fetch(url: "\(host)/api/service") { (result: (Result<[Service], Error>)?) in
//            defer { DispatchQueue.main.async { completion() } }
//
//            switch result {
//            case .success(let serverServices):
//                for i in 0...3 {
//                    self.services[i] = serverServices.filter {
//                        $0.category.id == i + 1
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            default :
//                break
//            }
//        }
//    }
//
//    private func fetch<T: Codable>(url: String, httpMethod: HttpMethod.RawValue = HttpMethod.GET.rawValue, body: Data? = nil, completion: @escaping ((Result<T, Error>)?) -> ()) {
//        guard let url = URL(string: url) else {
//            DispatchQueue.main.async {
//                completion(.failure(ApiError.invalidUrl))
//            }
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            var result: Result<T, Error>? = nil
//            defer { DispatchQueue.main.async { completion(result) } }
//            if let error = error { print(error); DispatchQueue.main.async { result = .failure(error) } }
//            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
//                result = .failure(ApiError.failed(response.statusCode))
//                return
//            }
//
//            guard let data = data else { result = .failure(ApiError.emptyData); return }
//
//            do {
//                let responseData = try JSONDecoder().decode(T.self, from: data)
//                result = .success(responseData)
//            } catch {
//                result = .failure(error)
//            }
//        }.resume()
//    }
//}
//
