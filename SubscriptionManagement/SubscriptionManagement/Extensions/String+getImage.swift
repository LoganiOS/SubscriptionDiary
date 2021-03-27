//
//  String+getImage.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/11.
//

import UIKit

extension String {
    
    func getImage(_ completion: @escaping (Data) -> ()) {
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
