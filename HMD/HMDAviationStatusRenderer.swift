//
//  HMDSpeedRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import DJISDK

class HMDAviationStatusRenderer: CALayer {
    
    var didSetup = false
    var operationMode = misc.operationMode.Hover
    
    
    var batteryLabel = HMDBatteryLabelLayer()
    var groundSpeedLabel = HMDGroundSpeedLabelLayer()
    var homeDistanceLabel = HMDHomeDistanceLabelLayer()
    var minutesToHomeLabel = HMDHomeDistanceLabelLayer()
    
    //Default values
    var labelHeight = CGFloat(16)
    var labelFontSize = CGFloat(12)
    
    func setup() {
        drawBattery()
        drawGroundSpeed()
        drawMission()
        
        switch operationMode {
        case .Home:
            registerLocationManagerDelegate()
        case .Cruise,.Hover, .Trans:
            //            registerLocationManagerDelegate()
//            startUpdatingAirSpeedData()
            startUpdatingGroundSpeedData()
        case .Camera:
//            startUpdatingAirSpeedData()
            startUpdatingGroundSpeedData()
        }
    }
    
    func unSetup() {
        
    }
    
    func drawBattery() {
        batteryLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: labelHeight)
        batteryLabel.contentsScale = UIScreen.main.scale
        batteryLabel.font = "Tahoma" as CFTypeRef
        batteryLabel.fontSize = labelFontSize
        batteryLabel.foregroundColor = StateColor.Normal
        batteryLabel.string = "100 %"
        addSublayer(batteryLabel)
    }
    func drawGroundSpeed() {
        groundSpeedLabel.frame = CGRect(x: 0, y: bounds.height.middle() - labelHeight.half(), width: bounds.width, height: labelHeight)
        groundSpeedLabel.contentsScale = UIScreen.main.scale
        groundSpeedLabel.font = "Tahoma" as CFTypeRef
        groundSpeedLabel.fontSize = labelFontSize
        groundSpeedLabel.foregroundColor = StateColor.Normal
        groundSpeedLabel.string = "100 m/s"
        addSublayer(groundSpeedLabel)
    }
    
    func drawMission() {
        homeDistanceLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight * 2, width: bounds.width, height: labelHeight)
        homeDistanceLabel.contentsScale = UIScreen.main.scale
        homeDistanceLabel.font = "Tahoma" as CFTypeRef
        homeDistanceLabel.fontSize = labelFontSize
        homeDistanceLabel.foregroundColor = StateColor.Normal
        homeDistanceLabel.string = "H: 8.8 Km"
        addSublayer(homeDistanceLabel)
        
        minutesToHomeLabel.frame = CGRect(x: 0, y: bounds.height - labelHeight, width: bounds.width, height: labelHeight)
        minutesToHomeLabel.contentsScale = UIScreen.main.scale
        minutesToHomeLabel.font = "Tahoma" as CFTypeRef
        minutesToHomeLabel.fontSize = labelFontSize
        minutesToHomeLabel.foregroundColor = StateColor.Normal
        minutesToHomeLabel.string = "00:04:47"
        addSublayer(minutesToHomeLabel)
    }
    //Data source updating
    let groundSpeedKey      = DJIFlightControllerKey(param: DJIFlightControllerParamVelocity)
    let batteryThresholdKey = DJIFlightControllerKey(param: DJIFlightControllerParamBatteryThresholdBehavior)
//    let batteryKey          = DJIFlightControllerKey(param: DJIbatter)
    func startUpdatingAirSpeedData(){
        
        
    }
    
    
    func startUpdatingGroundSpeedData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: groundSpeedKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let velocity = newValue!.value! as! DJISDKVector3D
                                                                self.updateGroundSpeedVelocity(CGFloat(velocity.x))
        })
        
    }
    
    func stopUpdatingGroundSpeedData(){
        
    }
    
    func registerLocationManagerDelegate(){
    
    }
    
    func updateGroundSpeedVelocity(_ velocity: CGFloat){
        let groundSpeed = Int(floor(Double(velocity)))
        groundSpeedLabel.string = "\(groundSpeed)"
    }
}

