//
//  HMDAircraftReferenceLayer.swift
//  HMD
//
//  Created by Yi JIANG on 22/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDAircraftReferenceLayer: CAShapeLayer {
    
    var operationMode = misc.operationMode.Trans
    var reticleLength :CGFloat = 10.0
    var referLength :CGFloat = 16.0
    var refergap: CGFloat = 6
    
    func setup(){
        switch operationMode {
        case .Home:
            drawSimpleAircraftReference()
        case .Hover:
            drawSimpleAircraftReference()
        case .Trans:
            drawSimpleAircraftReference()
        case .Cruise:
            drawSimpleAircraftReference()
        case .Camera:
            drawSimpleAircraftReference()
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
    
    func drawSimpleAircraftReference(){
        //Line 1
        var startPoint = CGPoint(x: frame.width.middle() - referLength - refergap, y: frame.height.middle())
        var endPoint = CGPoint(x: frame.width.middle() - refergap, y: frame.height.middle())
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 2
        startPoint = CGPoint(x: frame.width.middle() - refergap, y: frame.height.middle())
        endPoint = CGPoint(x: frame.width.middle() - refergap, y: frame.height.middle() + 7)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 3
        startPoint = CGPoint(x: frame.width.middle() + referLength + refergap, y: frame.height.middle() )
        endPoint = CGPoint(x: frame.width.middle() + refergap, y: frame.height.middle() )
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 4
        startPoint = CGPoint(x: frame.width.middle() + refergap, y: frame.height.middle())
        endPoint = CGPoint(x: frame.width.middle() + refergap, y: frame.height.middle() + 7)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        
    }

}
