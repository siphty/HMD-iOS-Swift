//
//  HMDLayer.swift
//  HMD
//
//  Created by Yi JIANG on 20/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import DJISDK

class HMDLayer: CALayer, CALayerDelegate {
    public var aircraft: DJIBaseProduct?
    var didSetup = false
    let headingTape     = HMDHeadingRenderer()
    let altitudeScale   = HMDAltitudeRenderer()
    let attitudeLayer   = HMDAttitudeRenderer()
    let statusLayer     = HMDAviationStatusRenderer()
    let losLayer        = HMDLineOfSightRenderer()
    
    public var operationMode = misc.operationMode.Hover {
        didSet
        {
            setup()
        }
    }   
    
    override func layoutSublayers() {
        print("layoutSublayers()")
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    override func display() {

    }
    
    func setup () {
        print("setup HMDLayer")
        masksToBounds = true

        //TODO: Use rate rather than precisely pixel size.
        headingTape.frame = CGRect(x: frame.width.middle() - 100,
                                   y: frame.height / 2 - 175,
                                   width: 200,
                                   height: 40)
        headingTape.operationMode = operationMode
        headingTape.setup()
        addSublayer(headingTape)
        

        //TODO: Use rate rather than precisely pixel size.
        altitudeScale.frame = CGRect(x: frame.width.middle() + 85,
                                     y: frame.height.middle() - 140,
                                     width: 75,
                                     height: 280)
        altitudeScale.operationMode = operationMode
        altitudeScale.setup()
        addSublayer(altitudeScale)
        

        attitudeLayer.frame = CGRect(x: frame.width.half() - 135,
                                     y: frame.height.half() - 135,
                                     width: 270,
                                     height: 270)
        attitudeLayer.operationMode = operationMode
        attitudeLayer.setup()
        addSublayer(attitudeLayer)
        
        statusLayer.frame = CGRect(x: frame.width.half() - 160,
                                  y: frame.height.half() - 145,
                                  width: 60,
                                  height: frame.height - 85)
//        statusLayer.borderWidth = 1
//        statusLayer.borderColor = UIColor.white.cgColor
        statusLayer.operationMode = operationMode
        statusLayer.setup()
        addSublayer(statusLayer)
        
        let losLayerOriginY = attitudeLayer.frame.origin.y + attitudeLayer.frame.size.height
        let losLayerFrameHeight = (frame.height - losLayerOriginY) * 0.8
        let losLayerFrameFill: CGFloat = bounds.size.width * 0.25
        let losLayerFrameWidth = frame.width - losLayerFrameFill * 2
        losLayer.frame = CGRect(x: losLayerFrameFill,
                                y: losLayerOriginY,
                                width: losLayerFrameWidth,
                                height: losLayerFrameHeight)
        losLayer.borderWidth = 1
        losLayer.borderColor = HMDColor.redScale
        losLayer.operationMode = operationMode
        losLayer.setup()
        addSublayer(losLayer)
    }
    
    func unSetup() {
        headingTape.unSetup()
        altitudeScale.unSetup()
        attitudeLayer.unSetup()
        statusLayer.unSetup()
        
        sublayers = nil
    }
}
