//
//  HMDMissionTimeLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 27/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDMissionTimeLabelLayer: CATextLayer {
    
    var operationMode = misc.operationMode.Hover
    
    //DJI key manager
    let flightTimeKey = DJIFlightControllerKey(param: DJIFlightControllerParamFlightTimeInSeconds)  // Speed
    
    
    func setup() {
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
        switch operationMode {
        case .Camera, .Home:
            startUpdatingFlightTime()
        case .Cruise, .Hover, .Trans:
            startUpdatingFlightTime()
        }
        startUpdatingFlightTime()
    }
    func unSetup() {
        stopUpdatingFlightTime()
    }
    
    
    func startUpdatingFlightTime() {
        DJISDKManager.keyManager()?.startListeningForChanges(on: flightTimeKey!,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?)  in
                                                                guard newValue != nil  else{ return }
                                                                let flightSeconds = newValue!.value! as! Int
                                                                self.foregroundColor = self.statusColor(by: flightSeconds)
                                                                self.string = String("\(self.hmsFromSeconds(flightSeconds))")
        })
    }
    
    func stopUpdatingFlightTime() {
        DJISDKManager.keyManager()?.stopListening(on: flightTimeKey!, ofListener: self)
    }
    
    func hmsFromSeconds(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func statusColor(by seconds: Int) -> CGColor {
        if seconds < 15 {
            return HMDColor.redScale
        }else if seconds >= 15 && seconds < 20 {
            return UIColor.yellow.cgColor
        }else {
            return UIColor.red.cgColor
        }
        
    }
}
