//
//  trackColor.swift
//  track_online
//
//  Created by 刈田修平 on 2019/10/05.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import Foundation
import UIKit

class trackColor {
    // 
    class var primary: UIColor {
        return rgbColor(rgbValue: 0xf99f48)
    }
    
    // 薄いオレンジを返す
    class var secondary: UIColor{
        return rgbColor(rgbValue: 0xFFFFFF)
    }
    
    // 白
    class var background: UIColor{
        return rgbColor(rgbValue: 0xFFFFFF)
    }
    
    // #FFFFFFのように色を指定できるようにするメソッド！色が使いやすくなる。
    // ここでしか使わないので privateメソッドにする。
    private class func rgbColor(rgbValue: UInt) -> UIColor{
        return UIColor(
            red:   CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgbValue & 0x0000FF)        / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
