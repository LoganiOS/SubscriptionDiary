//
//  Service(Codable).swift
//  SubscriptionManagement
//  Created by LoganBerry on 2021/03/01.

import UIKit

/**
 Service타입을 통해 서버로부터 요청한 데이터를 decoding할 수 있습니다.
 */
struct Service: Codable {
    
    
    /**
     서비스의 id값입니다.
     */
    let id: Int
    
    
    /**
     서비스의 카테고리 속성입니다.
     */
    let category: ServiceCategory
    
    
    /**
     카테고리의 id 속성입니다.
     */
    let categoryID: Int
    
    
    /**
     서비스의 한국어 이름입니다.
     */
    let koreanName: String
    
    
    /**
     서비스의 영문 이름입니다.
     */
    let englishName: String
    
    
    /**
     image가 저장된 URL 문자열입니다.
     */
    let imageURL: String
    
    
}
