//
//  FileManager.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/10.
//

import Foundation

extension FileManager {
    
    
    /**
     ApplicationGroupIdentifier에 쉽게 접근하기 위한 Type Method입니다.
     
     - returns : 전달된 application group identifier로 컨테이너 디렉토리를 리턴합니다.
     */
    static func sharedContainer() -> URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.gookjo.SubscriptionManagement")!
    }
    
}

