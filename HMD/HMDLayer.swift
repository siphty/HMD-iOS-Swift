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
    var isDroneView = true
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
        headingTape.frame = CGRect(x: frame.width / 2 - 120, y: frame.height / 2 - 175, width: 250, height: 40)
//        headingTape.borderColor = UIColor.lightGray.cgColor
//        headingTape.borderWidth = 1
        addSublayer(headingTape)
        
        //Fixed Reticle
        let reticle = CALayer()
        reticle.frame = CGRect(x: frame.width / 2 - 20, y: frame.height / 2 - 20, width: 40, height: 40)
        reticle.borderColor = UIColor.green.cgColor
        reticle.borderWidth = 1
        addSublayer(reticle)
        
        //Aircraft Reference
        let airCraftRef = CALayer()
        airCraftRef.frame = CGRect(x: frame.width / 2 - 10, y: frame.height / 2 - 10, width: 20, height: 20)
        airCraftRef.borderColor = UIColor.red.cgColor
        airCraftRef.borderWidth = 1
        addSublayer(airCraftRef)
        
        //Altitude Ladder
        let altitudeLadder = CALayer()
        altitudeLadder.frame = CGRect(x: frame.width / 2 + 110, y: frame.height / 2 - 110, width: 50, height: 220)
        altitudeLadder.borderColor = UIColor.blue.cgColor
        altitudeLadder.borderWidth = 1
        addSublayer(altitudeLadder)
        
        //Non-conformal Horizon
        let horizonLine = CALayer()
        horizonLine.frame = CGRect(x: frame.width / 2 - 100, y: frame.height / 2 - 100, width: 200, height: 200)
        horizonLine.borderColor = UIColor.lightGray.cgColor
        horizonLine.borderWidth = 1
        addSublayer(horizonLine)
        
        //Speed Number
        
        //Mode Annunciation
        
        //Sideslip
    }
}
