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
    var degreesPerLongScale: CGFloat = 5.0
    var degreesPerShortScale: CGFloat = 1.0
    var rangeForDegrees: ClosedRange = -20 ... 20
    var rangeForAccuracyDegrees: ClosedRange = -5 ... 5
    
    //Layers
    let replicateLongScales = CAReplicatorLayer()
    let instanceLayer = CALayer()
    
    func setup(){
        replicateLongScales.frame = bounds
        replicateLongScales.instanceCount = 40
        replicateLongScales.instanceColor = UIColor.hmdGreen.cgColor
        let tenDegreeAngle = Float(Double.pi * 2.0 / 36) /// Float(rangeForDegrees.count)
        replicateLongScales.instanceTransform = CATransform3DMakeRotation(CGFloat(tenDegreeAngle * (-1)), 0.0, 0.0, 1.0)

        let midX = bounds.midX - 1 / 2.0
        instanceLayer.frame = CGRect(x: midX, y: 10, width: 1, height: 5)
        instanceLayer.backgroundColor = UIColor.white.cgColor
        replicateLongScales.addSublayer(instanceLayer)
        addSublayer(replicateLongScales)
    }
    
}
