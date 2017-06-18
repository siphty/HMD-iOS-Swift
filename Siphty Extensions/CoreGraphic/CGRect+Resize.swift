//
//  CGRect+Resize.swift
//  HMD
//
//  Created by Yi JIANG on 9/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

extension CGRect {
    
    mutating func getScale(by rate: CGFloat) -> CGRect{
        var rect = CGRect()
        if rate <= 1.0 {
            rect.origin.x = size.width.half() * (1 - rate) / 2
            rect.origin.y = size.height.half() * (1 - rate) / 2
            rect.size.width = size.width * rate
            rect.size.height = size.height * rate
        }
        return rect
    }
}
