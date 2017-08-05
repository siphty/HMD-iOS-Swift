//
//  HMDBatteryLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 31/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDBatteryLabelLayer: CATextLayer {
    
    var operationMode = misc.operationMode.Hover
    
    //DJI key manager
    let aircraftBatteryKey = DJIBatteryKey(param: DJIBatteryParamChargeRemainingInPercent)  // Speed
    
    
    func setup() {
        switch operationMode {
        case .Camera, .Home:
            startUpdatingPhoneBatteryRemain()
        case .Cruise, .Hover, .Trans:
            startUpdatingBatteryRemain()
        }
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
    }
    
    
    func startUpdatingBatteryRemain() {
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftBatteryKey!,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?)  in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                print("\(newValue!.value! as! Int) %")
                                                                self.string = String("\(newValue!.value! as! Int) %")
        })
    }
    
    func stopUpdatingAircraftSpeed() {
        DJISDKManager.keyManager()?.stopListening(on: aircraftBatteryKey!, ofListener: self)
    }
    
    func startUpdatingPhoneBatteryRemain() {
        
    }
    
    
    
}
