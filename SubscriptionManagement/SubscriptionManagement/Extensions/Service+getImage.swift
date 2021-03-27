//
//  Service+getImage.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/03/11.
//

import Foundation

extension Service {
    
    func getImage(_ completion: @escaping (Data, String) -> ()) {
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
