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
    
    
    public var operationMode = misc.operationMode.Hover {
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
        let headingTape = HMDHeadingRenderer.init(operationMode)
        //        let headingTap = CALayer()
        //TODO: Use rate rather than precisely pixel size.
        headingTape.frame = CGRect(x: frame.width.middle() - 100, y: frame.height / 2 - 175, width: 200, height: 40)
//        headingTape.borderColor = UIColor.lightGray.cgColor
//        headingTape.borderWidth = 1
        
        headingTape.setup()
        addSublayer(headingTape)
        
          
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
        attitudeLayer.frame = CGRect(x: frame.width.half() - 135, y: frame.height.half() - 135, width: 270, height: 270)
//        attitudeLayer.borderColor = UIColor.lightGray.cgColor
//        attitudeLayer.borderWidth = 1
        attitudeLayer.setup()
        addSublayer(attitudeLayer)
        
        //Speed Number
        
        //Mode Annunciation
        
        //Sideslip
    }
}
