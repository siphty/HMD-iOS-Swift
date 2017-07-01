//
//  UIImage+Movement.swift
//  HMD
//
//  Created by Yi JIANG on 15/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

extension UIImage {
    func rotatedByDegrees(degrees: CGFloat, flip: Bool)   -> UIImage? {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let transform = CGAffineTransform.identity.rotated(by: degrees)
        rotatedViewBox.transform = transform
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()!
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
//        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0)
        bitmap.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        // // Rotate the image context
//        CGContextRotateCTM(bitmap, degreesToRadians(degrees))
        bitmap.rotate(by: degreesToRadians(degrees))
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if (flip) {
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap.scaleBy(x: yFlip, y: -1.0)
        
        bitmap.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
