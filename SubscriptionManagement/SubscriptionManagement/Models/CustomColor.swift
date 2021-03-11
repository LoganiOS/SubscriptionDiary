//
//  CustomColor.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit

public class CustomColor {
    static let shared = CustomColor()
    private init() {}
    
    var themes = [
        Theme(name: "Purple Theme", main: 0x5F5EFF, sub1: 0x8D8BFF, sub2: 0xC6C9FF),
        Theme(name: "Violet Theme", main: 0xA59BFA, sub1: 0xBCADF8, sub2: 0xC7C0FC),
        Theme(name: "Pink Theme", main: 0xEE959E, sub1: 0xEBA7AC, sub2: 0xF4C2C2),
        Theme(name: "Dark Green Theme", main: 0x0C8E7D, sub1: 0x16A7A1, sub2: 0xABD9C5),
        Theme(name: "Light Brown Theme", main: 0x908993, sub1: 0xB1A7A7, sub2: 0xE9DBCB)
    ]
    
    public struct Theme {
        let name: String
        let main: Int
        let sub1: Int
        let sub2: Int
    }
}
