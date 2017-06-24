//
//  CALayer+Extensions.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

extension CALayer {
    
//Properties
    
    func getColorfromPixel(_ pixelPoint:CGPoint) -> UIColor{
        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -pixelPoint.x, y: -pixelPoint.y)
        do {
            render(in: context!)
        } catch let error{
            print("error : \(error)")
        }
        
        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
        let green: CGFloat = CGFloat(pixel[1]) / 255.0
        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0
        
        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)
        
        return color
    }
    
    
//Draw Section
    func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, width: Int){
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = CGFloat(width)
        line.strokeColor = HMDColor.scale
        addSublayer(line)
    }
    
    func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, width: Int, isDash: Bool){
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = CGFloat(width)
        line.strokeColor = UIColor.green.cgColor
        if isDash {
            line.lineDashPattern = [4, 4]
        }
        addSublayer(line)
    }
    
    func withCircleFrame(){
        let circleLayer = CAShapeLayer()
        circleLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2).cgPath
        circleLayer.lineWidth = 0.6
        circleLayer.strokeColor = UIColor.hmdGreen.cgColor
        circleLayer.backgroundColor = UIColor.clear.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        addSublayer(circleLayer)
    }
    
    
//Animation section
    
    /// Transaction with animation
    ///
    /// - Parameters:
    ///   - actionsWithoutAnimation: <#actionsWithoutAnimation description#>
    ///   - handler: <#handler description#>
    class func performWithAnimation(_ actionsWithAnimation: () -> Void,
                                    completionHandler handler: @escaping() -> Void){
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.1)
        CATransaction.setDisableActions(false)
        CATransaction.setCompletionBlock({
            handler()
        })
        actionsWithAnimation()
        CATransaction.commit()
    }
    
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void,
                                       completionHandler handler: @escaping() -> Void){
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock({
            handler()
        })
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
    
    class func performAnimation(within duration: CFTimeInterval, action actionsWithAnimation: () -> Void,
                                    completionHandler handler: @escaping() -> Void){
                                        CATransaction.begin()
                                        CATransaction.setAnimationDuration(duration)
                                        CATransaction.setDisableActions(false)
                                        CATransaction.setCompletionBlock({
                                            handler()
        })
//        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithAnimation()
        CATransaction.commit()
    }
    
//Mask Section
    func doMask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        mask = maskLayer
    }
    
    func doMask(withPath path: UIBezierPath, inverse: Bool = false) {
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        mask = maskLayer
    }
    
    func doMask(by imageMask: UIImage) {
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRect(x: 0, y: 0, width: imageMask.size.width, height: imageMask.size.height)
        bounds = maskLayer.bounds
        maskLayer.contents = imageMask.cgImage
        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        mask = maskLayer
    }
    
    func doMaskWithBoard(by imageMask: UIImage) {
        let maskLayer = CAShapeLayer()
        maskLayer.bounds = CGRect(x: 0, y: 0, width: imageMask.size.width, height: imageMask.size.height)
        bounds = maskLayer.bounds
        maskLayer.contents = imageMask.cgImage
        maskLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        mask = maskLayer
    }
    
    func toImage() -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(bounds.size,
                                               isOpaque,
                                               UIScreen.main.scale)
        
        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    class func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(Double.pi) * a/180
        return b
    }
    

}
