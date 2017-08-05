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
        fillColor = UIColor.clear.cgColor
        frame = CGRect(x: 50, y: 50, width: 100, height: 100)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setup(){
        path = makeIndicatorPath().cgPath
        lineWidth = 1
        lineJoin = kCALineJoinMiter
        strokeColor = UIColor.yellow.cgColor
        backgroundColor = UIColor.clear.cgColor
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
    }
    
    func makeIndicatorPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width.half() - frame.height + 5,
                              y: frame.height))
        path.addLine(to: CGPoint(x: frame.width.half(),
                                 y: 0))
        path.addLine(to: CGPoint(x: frame.width.half() + frame.height - 5,
                                 y: frame.height))
//        path.addLine(to: CGPoint(x: frame.width.half(),
//                                 y: 0))
        path.close()
        //        path.apply(<#T##transform: CGAffineTransform##CGAffineTransform#>)
        return path
    }

}
