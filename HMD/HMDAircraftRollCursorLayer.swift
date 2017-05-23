//
//  HMDAirecraftRollCursorLayer.swift
//  HMD
//
//  Created by Yi JIANG on 22/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDAircraftRollCursorLayer: CAShapeLayer {
    
    var didSetup = false
    var pixelsForLongScale: CGFloat = 12
    
    public override init(){
        super.init()
        // Draw a triangle cursor
        
        
        contents = UIImage(named: "scale")?.cgImage
        contentsGravity = kCAGravityResizeAspect
        backgroundColor = UIColor.clear.cgColor
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
        fillColor = UIColor.clear.cgColor
    }
    
    func makeIndicatorPath() -> UIBezierPath{
        let path = UIBezierPath()
        path.move(to: CGPoint(x: frame.width.half() - 10 + 5,
                              y: 10 + pixelsForLongScale))
        path.addLine(to: CGPoint(x: frame.width.half(),
                                 y: 0 + pixelsForLongScale))
        path.addLine(to: CGPoint(x: frame.width.half() + 10 - 5,
                                 y: 10 + pixelsForLongScale))
        //        path.addLine(to: CGPoint(x: frame.width.half(),
        //                                 y: 0))
        path.close()
        //        path.apply(<#T##transform: CGAffineTransform##CGAffineTransform#>)
        return path
    }
}
