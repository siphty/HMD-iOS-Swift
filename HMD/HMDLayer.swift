//
//  HMDLayer.swift
//  HMD
//
//  Created by Yi JIANG on 20/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDLayer: CALayer, CALayerDelegate {
    
    var didSetup = false
    var operationMode = misc.operationMode.Home {
        didSet
        {
            setup()
        }
    }
    public override init(){
        super.init()
        print("init HMDLayer")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSublayers() {
        print("layoutSublayers()")
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    
    override func display() {
//        print("display()")
//        if !self.didSetup {
//            self.didSetup = true
//            self.setup()
//        }
    }
    
    func setup () {
        print("setup HMDLayer")
        masksToBounds = true
        
        
        //Heading
        let headingTape = HMDHeadingRenderer()
        //        let headingTap = CALayer()
        //TODO: Use rate rather than precisely pixel size.
        headingTape.frame = CGRect(x: frame.width.middle() - 100, y: frame.height / 2 - 175, width: 210, height: 40)
//        headingTape.borderColor = UIColor.lightGray.cgColor
//        headingTape.borderWidth = 1
        headingTape.operationMode = operationMode
        headingTape.setup()
        addSublayer(headingTape)
        
        //Fixed Reticle
        let reticle = CALayer()
        //TODO: Use rate rather than precisely pixel size.
        reticle.frame = CGRect(x: frame.width.half() - 20, y: frame.height.half() - 20, width: 40, height: 40)
        reticle.borderColor = UIColor.green.cgColor
        reticle.borderWidth = 1
        addSublayer(reticle)
        
        //Aircraft Reference
        //TODO: Use rate rather than precisely pixel size.
        let airCraftRef = CALayer()
        airCraftRef.frame = CGRect(x: frame.width.half() - 10, y: frame.height.half() - 10, width: 20, height: 20)
        airCraftRef.borderColor = UIColor.red.cgColor
        airCraftRef.borderWidth = 1
        addSublayer(airCraftRef)
        
        //Altitude Scale
        let altitudeScale = HMDAltitudeRenderer()
        //TODO: Use rate rather than precisely pixel size.
        altitudeScale.frame = CGRect(x: frame.width.middle() + 85,
                                     y: frame.height.middle() - 140,
                                     width: 75,
                                     height: 280)
//        altitudeScale.borderColor = UIColor.blue.cgColor
//        altitudeScale.borderWidth = 1
        altitudeScale.setup()
        addSublayer(altitudeScale)
        
        let attitudeLayer = HMDAttitudeRenderer()
        attitudeLayer.frame = CGRect(x: frame.width.half() - 100, y: frame.height.half() - 100, width: 200, height: 200)
        attitudeLayer.borderColor = UIColor.lightGray.cgColor
        attitudeLayer.borderWidth = 1
        attitudeLayer.setup()
        addSublayer(attitudeLayer)
        
        //Speed Number
        
        //Mode Annunciation
        
        //Sideslip
    }
}