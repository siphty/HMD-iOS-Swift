//
//  CALayer+Extensions.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

extension CALayer {
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
        CATransaction.setAnimationDuration(0.01)
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
}
