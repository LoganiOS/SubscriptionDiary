//
//  Service(Codable).swift
//  SubscriptionManagement
//  Created by LoganBerry on 2021/03/01.

import UIKit

struct Service: Codable {
    
    let id: Int
    let category: ServiceCategory
    let categoryID: Int
    let koreanName: String
    let englishName: String
    let imageURL: String
    
}
