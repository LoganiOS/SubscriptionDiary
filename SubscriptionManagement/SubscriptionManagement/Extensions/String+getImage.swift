//
//  String+getImage.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/11.
//

import UIKit


extension String {
    
    
    /**
     이 method를 호출한 속성을 통해 URL 인스턴스를 생성한 다음 클로저로 URL을 기반으로 생성한 Data 타입 속성을 전달합니다.
     
     - parameter completion: @escaping Block입니다.
     - parameter data: URL로 생성한 Data 속성이 전달됩니다.
     
     - returns: 최초로 이 method가 실행될 때 전달된 문자열과 서버 URL과 일치한다면 URL로 Data를 생성하고 cachesDirectory에 저장합니다. 두번째 이후로 이 method가 실행되면 cachesDirectory에 저장된 path가 있는지 확인하고 있다면 해당 path를 사용해 Data를 생성합니다.
     일치하는 path가 없다면 다시 서버 URL로 Data를 생성합니다.
     */
    func getImage(_ completion: @escaping (_ data: Data) -> ()) {
        DispatchQueue.global().async {
            var data = Data()
            defer { DispatchQueue.main.async { completion(data) } }
            
            let manager = FileManager.default
            let cachesDirectories = manager.urls(for: .cachesDirectory, in: .userDomainMask)
            let cachesDirectory = cachesDirectories[0]
            
            var imageURL = cachesDirectory.appendingPathComponent(self)
            let path = imageURL.path
            
            if manager.fileExists(atPath: path) {
                if let imageData = try? Data(contentsOf: imageURL) {
                    data = imageData
                    imageURL.excludeFromBackup()
                }
            } else {
                if let imageLink = URL(string: self) {
                    if let imageData = try? Data(contentsOf: imageLink) {
                        manager.createFile(atPath: path, contents: imageData)
                        data = imageData
                    }
                }
            }
        }
    }
    
    
    /**
     이 method를 호출한 속성을 통해 URL 인스턴스를 생성한 다음 데이터를 리턴합니다.
     
     이 method는 writeSharedJson(list:) method 안에서만 호출해야합니다.
     
     - returns: 최초로 이 method가 실행될 때 전달된 문자열과 서버 URL과 일치한다면 URL로 Data를 리턴하고 cachesDirectory에 저장합니다. 두번째 이후로 이 method가 실행되면 cachesDirectory에 저장된 path가 있는지 확인하고 있다면 해당 path를 사용해 Data를 리턴합니다.
     일치하는 path가 없다면 다시 서버 URL로 Data를 생성합니다.
     */
    func getImageData() -> Data {
        let manager = FileManager.default
        let cachesDirectories = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectory = cachesDirectories[0]
        let imageURL = cachesDirectory.appendingPathComponent(self)
        let path = imageURL.path
       
        if manager.fileExists(atPath: path) {
            if let imageData = try? Data(contentsOf: imageURL) {
                return imageData
            }
        } else {
            if let imageLink = URL(string: self) {
                if let imageData = try? Data(contentsOf: imageLink) {
                    manager.createFile(atPath: path, contents: imageData)
                    return imageData
                }
            }
        }
        
        return Data()
    }
    
}
