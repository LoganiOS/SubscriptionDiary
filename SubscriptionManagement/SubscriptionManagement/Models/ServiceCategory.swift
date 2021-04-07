//
//  ServiceCategory.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/27.
//

import UIKit


/**
 Service의 category 속성의 타입입니다.
 */
struct ServiceCategory: Codable {
    
    
    /**
     카테고리의 id입니다.
     */
    let id: Int
    
    
    /**
     카테고리 이름을 나타내는 속성입니다.
     */
    let name: String
    
    
}
