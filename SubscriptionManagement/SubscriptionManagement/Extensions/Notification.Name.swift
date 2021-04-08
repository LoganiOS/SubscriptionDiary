//
//  Notification.Name.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2020/12/01.
//

import Foundation


extension Notification.Name {
    
    
    /**
     사용자가 서비스를 추가하는 경우 Notification을 보내고 싶다면 이 Notification.Name을 사용합니다.
     */
    static let serviceDidAdd = Notification.Name("serviceDidAdd")
    
    
    /**
     사용자가 서비스를 삭제하는 경우 Notification을 보내고 싶다면 이 Notification.Name을 사용합니다.
     */
    static let serviceDidDelete = Notification.Name("serviceDidDelete")
    
    
    /**
     사용자가 서비스를 수정하는 경우 Notification을 보내고 싶다면 이 Notification.Name을 사용합니다.
     */
    static let serviceDidUpdate = Notification.Name("serviceDidUpdate")
    
    
    /**
     사용자가 ChangeIconViewController에서 이미지를 선택했을 경우 Notification을 보내고 싶다면 이 Notification.Name을 사용합니다.
     */
    static let imageDidSelecte = Notification.Name("imageDidSelecte")
    
    
    /**
     사용자가 구독 시작일을 선택했을 경우 Notification을 보내고 싶다면 이 Notification.Name을 사용합니다.
     */
    static let startDateDidSelecte = Notification.Name("startDateDidSelecte")
    
    
    /**
     사용자가 구독 갱신일을 선택했을 경우 Notification을 보내고 싶다면 이 Notification.Name을 사용합니다.
     */
    static let renewalDateDidSelecte = Notification.Name("renewalDateDidSelecte")
}
