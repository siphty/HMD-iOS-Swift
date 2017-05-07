//
//  CALayer+Extensions.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

extension CALayer {
    class func performWithAnimation(_ actionsWithoutAnimation: () -> Void,
                                    completionHandler handler: @escaping() -> Void){
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.01)
        CATransaction.setDisableActions(false)
        CATransaction.setCompletionBlock({
            handler()
        })
        actionsWithoutAnimation()
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
