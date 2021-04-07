//
//  Moya.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/12.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import Alamofire


/**
 MoyaProvider에 사용할 TargetType입니다.
 
 이 열거형의 case를 전달하면 서버로부터 연관된 api를 요청합니다.
 */
enum ServiceProvider {
    case services
}



// MARK: - Moya TargetType
extension ServiceProvider: TargetType {

    
    var baseURL: URL {
        switch self {
        case .services:
            return URL(string: "https://subscriptiondiary.azurewebsites.net")!
        }
    }
    
    var path: String {
        switch self {
        case .services:
            return "/api/service"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .services:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .services:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .services:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type":"application/json"]
    }
    
    
}
