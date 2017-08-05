//
//  HMDSideslipLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDSideslipLayer: CALayer {
    var sideslipCursor = CAShapeLayer()
    var operationMode = misc.operationMode.Hover
    
    func setup(){
        switch operationMode {
        case .Home:
            drawHeadingReference()
            drawSideslipCursor()
        case .Hover:
            drawHeadingReference()
            drawSideslipCursor()
        case .Trans:
            drawHeadingReference()
            drawSideslipCursor()
        case .Cruise:
            drawHeadingReference()
            drawSideslipCursor()
        case .Camera:
            drawHeadingReference()
            drawSideslipCursor()
        }
        
    }
    
    func drawHeadingReference() {
        let leftLineStartPoint = CGPoint(x: bounds.size.width.half() - bounds.size.height.half(), y: 0)
        let leftLineEndPoint = CGPoint(x: bounds.size.width.half() - bounds.size.height.half(), y: bounds.size.height)
        drawLine(fromPoint: leftLineStartPoint,
                 toPoint: leftLineEndPoint,
                 width: 2)
        
        let rightLineStartPoint = CGPoint(x: bounds.size.width.middle() + bounds.size.height.half(), y: 0)
        let rightLineEndPoint = CGPoint(x: bounds.size.width.middle() + bounds.size.height.half(), y: bounds.size.height)
        drawLine(fromPoint: rightLineStartPoint,
                 toPoint: rightLineEndPoint,
                 width: 2)
        
//        let bottomLineStartPoint = CGPoint(x: 0, y:  bounds.size.height)
//        let bottomLineEndPoint = CGPoint(x: bounds.size.width, y: bounds.size.height)
//        drawLine(fromPoint: bottomLineStartPoint,
//                 toPoint: bottomLineEndPoint,
//                 width: 1)
    }
    
    func drawSideslipCursor() {
        let cursorCenter = CGPoint(x: bounds.size.width.middle(), y: bounds.size.height.middle())
        let cursorRadius = bounds.size.height.half() * 0.7
        let circlePath = UIBezierPath(arcCenter: cursorCenter,
                                      radius: cursorRadius,
                                      startAngle: CGFloat(0),
                                      endAngle:CGFloat(Double.pi * 2),
                                      clockwise: true)
        sideslipCursor.path = circlePath.cgPath
        sideslipCursor.fillColor = UIColor.clear.cgColor
        sideslipCursor.strokeColor = HMDColor.redScale
        sideslipCursor.lineWidth = 2.0
        sideslipCursor.shadowColor = LayerShadow.Color
        sideslipCursor.shadowOffset = LayerShadow.Offset
        sideslipCursor.shadowRadius = LayerShadow.Radius
        sideslipCursor.shadowOpacity = LayerShadow.Opacity
        addSublayer(sideslipCursor)
    }
}
