//
//  HMDRemainingFlightTimeLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 28/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDRemainingFlightTimeLabelLayer: CATextLayer {
    
    var operationMode = misc.operationMode.Hover
    
    //DJI key manager
    let remainingFlightTimeKey = DJIFlightControllerKey(param: DJIFlightControllerParamRemainingFlightTime)  // Speed
    
    
    func setup() {
        switch operationMode {
        case .Camera, .Home:
            startUpdatingRemainingFlightTime()
        case .Cruise, .Hover, .Trans:
            startUpdatingRemainingFlightTime()
        }
        startUpdatingRemainingFlightTime()
    }
    func unSetup() {
        stopUpdatingRemainingFlightTime()
    }
        
        
    func startUpdatingRemainingFlightTime() {
        DJISDKManager.keyManager()?.startListeningForChanges(on: remainingFlightTimeKey!,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?)  in
                                                                guard newValue != nil  else{ return }
                                                                let remainingSeconds = newValue!.value! as! Int
                                                                self.string = String("\(self.hmsFromSeconds(remainingSeconds))")
        })
    }
    
    func stopUpdatingRemainingFlightTime() {
        DJISDKManager.keyManager()?.stopListening(on: remainingFlightTimeKey!, ofListener: self)
    }
    
    func hmsFromSeconds(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
