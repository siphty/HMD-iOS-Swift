//
//  HMDRemoteControllerThrustCursorLayer.swift
//  HMD
//
//  Created by Yi JIANG on 23/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDRemoteControllerThrustCursorLayer: CAShapeLayer {
    
    func setup(){
        path = makeIndicatorPath().cgPath
        strokeColor = UIColor.hmdGreen.cgColor
        lineWidth = 1
        lineJoin = kCALineJoinMiter
        fillColor = UIColor.clear.cgColor
        lineDashPattern = [1,1]
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
        return path
    }
    

}
