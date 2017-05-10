//
//  HMDBankScaleLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDBankScaleLayer: CALayer {
    //Configuration
    var pixelsForLongScale: CGFloat = 12
    var pixelsForShoreScale: CGFloat = 8
    var rangeForDegrees: ClosedRange = -20 ... 20
    var rangeForAccuracyDegrees: ClosedRange = -5 ... 5
    
    //Layers
    let replicateLongScales = CAReplicatorLayer()
    let instanceLayer = CALayer()
    
    func setup(){
        
        drawCircleScale(number: 1,
                        angle: 0.0,
                        length: pixelsForLongScale + 4,
                        color: UIColor.green.cgColor)
        drawCircleScale(number: 7,
                        angle: 10.0,
                        length: pixelsForLongScale,
                        color: UIColor.green.cgColor)
        drawCircleScale(number: 13,
                        angle: 5.0,
                        length: pixelsForShoreScale,
                        color: UIColor.green.cgColor)
    }
    
    func drawCircleScale(number count: Int, angle degree: CGFloat, length lenth: CGFloat, color: CGColor) {
        let replicateScales = CAReplicatorLayer()
        replicateScales.frame = bounds
        replicateScales.instanceCount = count
        replicateScales.instanceColor = UIColor.green.cgColor
        let degreeAngle = CGFloat(Double.pi * 2.0) * (degree/360.0)
        replicateScales.instanceTransform = CATransform3DMakeRotation(degreeAngle, 0.0, 0.0, 1.0)
        
        let midX = bounds.midX - 1 / 2.0
        let instanceLayer = CALayer()
        instanceLayer.frame = CGRect(x: midX, y: 0, width: 1, height: lenth)
        instanceLayer.backgroundColor = UIColor.white.cgColor
        replicateScales.addSublayer(instanceLayer)
        let spanAngle = CGFloat(count - 1) * (degree/360.0) * CGFloat(Double.pi * 2.0) * -1/2
        replicateScales.transform = CATransform3DMakeRotation(spanAngle , 0, 0, 1.0)
        addSublayer(replicateScales)
    }
    
}
