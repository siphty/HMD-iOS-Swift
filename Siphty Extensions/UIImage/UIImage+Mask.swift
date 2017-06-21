//
//  UIImage+Mask.swift
//  HMD
//
//  Created by Yi JIANG on 21/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation


extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        
        let maskLayer = CALayer()
        maskLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        maskLayer.backgroundColor = color.cgColor
        maskLayer.doMask(by: self)
        let maskImage = maskLayer.toImage()
        return maskImage
    }
    
}
