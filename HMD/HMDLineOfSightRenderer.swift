//
//  HMDLineOfSightRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 27/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class HMDLineOfSightRenderer: CALayer {
    var sightBox = CALayer()
    
    
    var didSetup = false
    var operationMode = misc.operationMode.Hover
    
    func setup() {
        borderColor = HMDColor.scale
        borderWidth = 2
        
        drawSightBox()
    }

    
    func unSetup() {
        
    }
    
    func drawSightBox() {
        //Camera 94.5/2: 40.86
        //Gimble 180: 120
        let cameraGimbleWidthProportion: CGFloat = 0.2625   //  (94.5/2) / 180
        let cameraGimbleHeightProportion: CGFloat = 0.333   //  40 / 120
        let sightBoxFrameHeight = bounds.height * cameraGimbleHeightProportion
        let sightBoxFrameWidth = bounds.width * cameraGimbleWidthProportion
        let sightBoxOriginX = bounds.width.middle() - sightBoxFrameWidth.half()
        let sightBoxOriginY = bounds.height * 0.25 - sightBoxFrameHeight.half()
        sightBox.frame = CGRect(x: sightBoxOriginX, y: sightBoxOriginY, width: sightBoxFrameWidth, height: sightBoxFrameHeight)
        sightBox.borderColor = HMDColor.scale
        sightBox.borderWidth = 1
        addSublayer(sightBox)
    }

}
