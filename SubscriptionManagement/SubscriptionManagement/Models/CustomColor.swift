//
//  CustomColor.swift
//  SubscriptionManagement
//
//  Created by LoganBerry on 2021/02/02.
//

import UIKit


/**
 앱의 테마를 변경할 수 있는 class입니다.
 
 싱글톤 패턴의 CustomColor class입니다. shared 속성에 한 번만 메모리를 할당하고 이 메모리에 객체를 만들어 사용합니다.
 */
public class CustomColor {
    
    
    /**
     CustomColor 타입의 속성입니다.
     */
    static let shared = CustomColor()
    
    
    private init() { }
    
    
    /**
     색상의 테마입니다.
     
     각 속성의 역할은 아래와 같습니다.
     - name: 테마의 이름
     - main: 메인 컬러
     - sub1: 서브 컬러1
     - sub2: 서브 컬러2
     
     main, sub1, sub2 속성엔 반드시 Hex Color Code가 들어가야합니다.
     */
    public struct Theme {
        let name: String
        let main: Int
        let sub1: Int
        let sub2: Int
    }
    
    
    /**
     이 배열은 ColorSettingViewController에서 CollectionView Cell의 데이터소스로 사용됩니다.
     */
    var themes = [
        Theme(name: "Purple Theme", main: 0x5F5EFF, sub1: 0x8D8BFF, sub2: 0xC6C9FF),
        Theme(name: "Violet Theme", main: 0xA59BFA, sub1: 0xBCADF8, sub2: 0xC7C0FC),
        Theme(name: "Pink Theme", main: 0xEE959E, sub1: 0xEBA7AC, sub2: 0xF4C2C2),
        Theme(name: "Dark Green Theme", main: 0x0C8E7D, sub1: 0x16A7A1, sub2: 0xABD9C5),
        Theme(name: "Light Brown Theme", main: 0x908993, sub1: 0xB1A7A7, sub2: 0xE9DBCB)
    ]
    

}

