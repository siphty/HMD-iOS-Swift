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
    var refergap: CGFloat = 6
    
    var boxLength :CGFloat = 10.0
    
    func setup(){
        switch operationMode {
        case .Home:
            drawBoxReticle()
        case .Hover:
            drawCrossReticle()
        case .Trans:
            drawCrossReticle()
        case .Cruise:
            drawBoxReticle()
        }
        
    }
    
    func drawCrossReticle(){
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
    
    func drawBoxReticle(){
        //Line 1
        var startPoint = CGPoint(x: frame.width.middle() - 4 * boxLength, y: frame.height.middle() - 4 * boxLength)
        var endPoint = CGPoint(x: frame.width.middle() - 3 * boxLength, y: frame.height.middle() - 4 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 2
        startPoint = CGPoint(x: frame.width.middle() + 3 * boxLength, y: frame.height.middle() - 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() + 4 * boxLength, y: frame.height.middle() - 4 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 3
        startPoint = CGPoint(x: frame.width.middle() - 4 * boxLength, y: frame.height.middle() + 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() - 3 * boxLength, y: frame.height.middle() + 4 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 4
        startPoint = CGPoint(x: frame.width.middle() + 3 * boxLength, y: frame.height.middle() + 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() + 4 * boxLength, y: frame.height.middle() + 4 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 5
        startPoint = CGPoint(x: frame.width.middle() - 4 * boxLength, y: frame.height.middle() - 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() - 4 * boxLength, y: frame.height.middle() - 3 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 6
        startPoint = CGPoint(x: frame.width.middle() + 4 * boxLength, y: frame.height.middle() - 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() + 4 * boxLength, y: frame.height.middle() - 3 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 7
        startPoint = CGPoint(x: frame.width.middle() - 4 * boxLength, y: frame.height.middle() + 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() - 4 * boxLength, y: frame.height.middle() + 3 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        //Line 8
        startPoint = CGPoint(x: frame.width.middle() + 4 * boxLength, y: frame.height.middle() + 4 * boxLength)
        endPoint = CGPoint(x: frame.width.middle() + 4 * boxLength, y: frame.height.middle() + 3 * boxLength)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
        
        
    }

}
