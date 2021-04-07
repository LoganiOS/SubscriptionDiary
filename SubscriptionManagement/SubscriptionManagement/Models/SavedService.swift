//
//  SavedService.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/12.
//

import UIKit
import WidgetKit


/**
 이 구조체는 Widget에 데이터를 전달하는 목적으로만 사용됩니다.
 
 사용자가 추가한 서비스 배열을 encoding해 Widget에 전달하는 목적으로 사용됩니다.
 */
public struct SavedService: Codable {
    
    
    /**
     사용자가 추가한 서비스의 이름입니다.
     */
    let name: String
    
    
    /**
     사용자가 추가한 서비스의 이미지의 데이터입니다.
     */
    let icon: Data
    
    
    /**
     사용자가 추가한 서비스의 결제예상금액입니다.
     */
    let payment: String
    
    
    /**
     사용자가 추가한 서비스의 결제 예상일들 중 가장 빠른 결제일입니다.
     */
    let paymentDate: Date
   
    
    /**
     사용자가 추가한 서비스가 없는 경우 배열에 4개의 default 요소를 저장합니다.
     */
    static var dummy: [SavedService] {
        return (0...3).map { _ in
            SavedService(name: "-", icon: Data(), payment: "-", paymentDate: Date())
        }
    }
    
}




