//
//  HMDAltitudeStickLayer.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDAltitudeStickLayer: CALayer {
    
    public override init(){
        super.init()
        print("init HMDAltitudeStickLayer")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(){
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
    }
    
    func update(_ alti:CGFloat){
        
    }
}
