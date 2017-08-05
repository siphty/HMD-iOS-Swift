//
//  HMDVerticalSpeedIndicatorLayer.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDVerticalVelocityCursorLayer: CAShapeLayer {

    
    func setup(){
        path = makeIndicatorPath().cgPath
        fillColor = UIColor.hmdGreen.cgColor
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
    }
    
    func makeIndicatorPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0,
                              y: frame.height.half() - frame.width))
        path.addLine(to: CGPoint(x: frame.width,
                                 y: frame.height.half()))
        path.addLine(to: CGPoint(x: 0,
                                 y: frame.height.half() + frame.width))
        path.close()
//        path.apply(<#T##transform: CGAffineTransform##CGAffineTransform#>)
        return path
    }
    

}
