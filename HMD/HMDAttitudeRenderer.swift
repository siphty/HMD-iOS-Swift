//
//  HMDAttitudeRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation


class HMDAttitudeRenderer: CALayer {
    
    //Configuration
    var didSetup = false
    var operationMode = misc.operationMode.Home
    
    //Spin layers group
    var spinLayer = CALayer()
    var bankScale = HMDBankScaleLayer()
    var pitchLadder = HMDPitchLadderLayer()
    var aircraftReference = CALayer()
    
    
    //Fixed Layers
    var visualCentreDatum = CALayer() //Camera (iPhone/Drone) visual centre datum 摄像头中心基准线
    var sideslip = HMDSideslipLayer()
    var hoverVector = CAShapeLayer()
    var viewAreaReference = CALayer()

    
    
    func setup () {
        spinLayer.frame = bounds.getScale(by: 0.9)
        
        bankScale.frame = spinLayer.bounds
        bankScale.setup()
        
        spinLayer.addSublayer(bankScale)
        
        addSublayer(spinLayer)
        
    }
    
}
