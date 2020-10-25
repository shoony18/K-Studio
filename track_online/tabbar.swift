//
//  tabbar.swift
//  track_online
//
//  Created by 刈田修平 on 2019/10/05.
//  Copyright © 2019年 刈田修平. All rights reserved.
//

import Foundation

class TabBar: UITabBar {
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 40
        return size
    }
    
}
