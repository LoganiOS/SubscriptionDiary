//
//  Service+getImage.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/11.
//

import Foundation


extension Service {
    
    
    /**
     imageURL 속성으로부터 URL 인스턴스를 생성한 다음 클로저로 URL을 기반으로 생성한 Data 타입 속성을 전달합니다.
     
     - parameter completion: @escaping Block입니다.
     - parameter data: URL로 생성한 Data 속성이 전달됩니다.
     - parameter string: URL을 문자열로 전달합니다.
     
     - returns: 최초로 이 method가 실행될 때 전달된 문자열과 서버 URL과 일치한다면 URL로 Data를 생성하고 cachesDirectory에 저장합니다. 두번째 이후로 이 method가 실행되면 cachesDirectory에 저장된 path가 있는지 확인하고 있다면 해당 path를 사용해 Data를 생성합니다.
     일치하는 path가 없다면 다시 서버 URL로 Data를 생성합니다.
     */
    func getImage(_ completion: @escaping (_ data: Data, _ string: String) -> ()) {
        DispatchQueue.global().async {
            var data = Data()
            var imageURLString: String = ""
            defer { DispatchQueue.main.async { completion(data, imageURLString) } }

            let manager = FileManager.default
            let cachesDirectories = manager.urls(for: .cachesDirectory, in: .userDomainMask)
            let cachesDirectory = cachesDirectories[0]
            
            guard let fileName = self.imageURL.components(separatedBy: "/").last else { return }
            var imageURL = cachesDirectory.appendingPathComponent(fileName)
            let path = imageURL.path
            if manager.fileExists(atPath: path) {
                if let imageData = try? Data(contentsOf: imageURL) {
                    data = imageData
                    imageURLString = fileName
                    imageURL.excludeFromBackup()
                }
            } else {
                if let imageLink = URL(string: self.imageURL) {
                    if let imageData = try? Data(contentsOf: imageLink) {
                        manager.createFile(atPath: path, contents: imageData)
                        imageURLString = fileName
                        data = imageData
                    }
                }
            }
        }
    }
    
}
