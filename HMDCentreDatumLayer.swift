//
//  HMDCentreDatumLayer.swift
//  HMD
//
//  Created by Yi JIANG on 10/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDCentreDatumLayer: CALayer {
    
    
    var operationMode = misc.operationMode.Cruise
    var reticleLength :CGFloat = 10.0
    var referLength :CGFloat = 20.0
    func setup(){
        switch operationMode {
        case .Home:
            drawReticle()
        case .Hover:
            drawReticle()
        case .Trans:
            drawAircraftReference()
        case .Cruise:
            drawAircraftReference()
        }
        
    }
    
    func drawReticle(){
        //Line 1
        var startPoint = CGPoint(x: frame.width.middle(), y: frame.height.middle() - reticleLength )
        var endPoint = CGPoint(x: frame.width.middle(), y: frame.height.middle() - reticleLength * 2 )
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 2
        startPoint = CGPoint(x: frame.width.middle() - reticleLength, y: frame.height.middle() )
        endPoint = CGPoint(x: frame.width.middle() - reticleLength * 2, y: frame.height.middle() )
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 3
        startPoint = CGPoint(x: frame.width.middle() + reticleLength, y: frame.height.middle() )
        endPoint = CGPoint(x: frame.width.middle() + reticleLength * 2, y: frame.height.middle() )
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 4
        startPoint = CGPoint(x: frame.width.middle(), y: frame.height.middle() + reticleLength)
        endPoint = CGPoint(x: frame.width.middle(), y: frame.height.middle() + reticleLength * 2)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
      
        
    }
    
    func drawAircraftReference(){
        //Line 1
        var startPoint = CGPoint(x: frame.width.middle() - referLength - 10, y: frame.height.middle())
        var endPoint = CGPoint(x: frame.width.middle() - 10, y: frame.height.middle())
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 2
        startPoint = CGPoint(x: frame.width.middle() - 10, y: frame.height.middle())
        endPoint = CGPoint(x: frame.width.middle() - 10, y: frame.height.middle() + 7)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 3
        startPoint = CGPoint(x: frame.width.middle() + referLength + 10, y: frame.height.middle() )
        endPoint = CGPoint(x: frame.width.middle() + 10, y: frame.height.middle() )
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 4
        startPoint = CGPoint(x: frame.width.middle() + 10, y: frame.height.middle())
        endPoint = CGPoint(x: frame.width.middle() + 10, y: frame.height.middle() + 7)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        
    }

}
