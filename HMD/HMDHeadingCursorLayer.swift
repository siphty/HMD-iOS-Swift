//
//  HMDRulerCursorLayer.swift
//  HMD
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDHeadingCursorLayer: CAShapeLayer {
    
    var didSetup = false
//    var 
    
    public override init(){
        super.init()
        // Draw a triangle cursor
        
        
        contents = UIImage(named: "scale")?.cgImage
        contentsGravity = kCAGravityResizeAspect
        backgroundColor = UIColor.clear.cgColor
        frame = CGRect(x: 50, y: 50, width: 100, height: 100)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setup(){
        path = makeIndicatorPath().cgPath
        lineWidth = 2
        lineJoin = kCALineJoinMiter
        strokeColor = UIColor.hmdGreen.cgColor
    }
    
    func makeIndicatorPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width.half() - frame.height,
                              y: frame.height))
        path.addLine(to: CGPoint(x: frame.width.half(),
                                 y: 0))
        path.addLine(to: CGPoint(x: frame.width.half() + frame.height,
                                 y: frame.height))
        path.addLine(to: CGPoint(x: frame.width.half(),
                                 y: 0))
        path.close()
        //        path.apply(<#T##transform: CGAffineTransform##CGAffineTransform#>)
        return path
    }

}