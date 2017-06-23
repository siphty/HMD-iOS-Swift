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
        
        let shadowLayer = CALayer()
        shadowLayer.bounds = CGRect(x: -1, y: -1, width: size.width + 2, height: size.height + 2)
        shadowLayer.backgroundColor = UIColor.black.cgColor
        shadowLayer.contentsGravity = kCAGravityResizeAspect
        shadowLayer.doMask(by: self)
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 1, y: 1, width: size.width - 2, height: size.height - 2)
        maskLayer.backgroundColor = color.cgColor
        maskLayer.contentsGravity = kCAGravityResizeAspect
        maskLayer.doMask(by: self)
        shadowLayer.addSublayer(maskLayer)
        let maskShadowImage = shadowLayer.toImage()
        return maskShadowImage
    }
    
}
