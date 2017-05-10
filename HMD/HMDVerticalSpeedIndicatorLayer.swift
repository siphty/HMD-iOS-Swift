//
//  HMDVerticalSpeedIndicatorLayer.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDVerticalSpeedIndicatorLayer: CAShapeLayer {
    
    public override init(){
        super.init()
        print("init HMDVerticalSpeedIndicatorLayer")
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(){
        path = makeIndicatorPath().cgPath
        fillColor = UIColor.hmdGreen.cgColor
        
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
