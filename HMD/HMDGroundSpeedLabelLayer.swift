//
//  HMDGroundSpeedLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import DJISDK

class HMDGroundSpeedLabelLayer: CATextLayer {
    
    var operationMode = misc.operationMode.Hover
    
    //DJI key manager
    let aircraftVelocityKey = DJIFlightControllerKey(param: DJIFlightControllerParamVelocity)  // Speed
    
    func setup() {
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
        alignmentMode = kCAAlignmentRight
        switch operationMode {
        case .Camera, .Home:
            startUpdatingPhoneSpeed()
        case .Cruise, .Hover, .Trans:
            startUpdatingAircraftSpeed()
        }
    }
    
    func startUpdatingAircraftSpeed() {
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftVelocityKey!,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?)  in
                                                                guard newValue != nil  else{
                                                                    return
                                                                }
                                                                let velocityVector = newValue!.value! as! DJISDKVector3D
                                                                let velocity = sqrt(velocityVector.x * velocityVector.x + velocityVector.y * velocityVector.y)
                                                                self.string = String("\(velocity) m/s")
        })
    }
    
    func stopUpdatingAircraftSpeed() {
        DJISDKManager.keyManager()?.stopListening(on: aircraftVelocityKey!, ofListener: self)
    }
    
    func startUpdatingPhoneSpeed() {
        
    }
    
    func stopUpdatingPhoneSpeed() {
        
    }

}
