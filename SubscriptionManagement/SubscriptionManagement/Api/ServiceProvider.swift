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

enum ServiceProvider {
    case services
}

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
