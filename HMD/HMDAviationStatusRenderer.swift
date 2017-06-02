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
    
    var airSpeedLabel = HMDAirSpeedLabelLayer()
    var groundSpeedLabel = HMDGroundSpeedLabelLayer()
    
    var locationManager = CLLocationManager()
    var motionManager = CMMotionManager()
    
    //Default values
    var airSpeedLabelHeight = CGFloat(18)
    var airSpeedLabelFontSize = CGFloat(14)
    var groundSpeedLabelHeight = CGFloat(18)
    var groundSpeedLabelFontSize = CGFloat(16)
    
    func setup() {
        drawGroundSpeed()
//        drawAirSpeed()
        
        switch operationMode {
        case .Home:
            registerLocationManagerDelegate()
        case .Cruise,.Hover, .Trans:
            //            registerLocationManagerDelegate()
            startUpdatingAirSpeedData()
            startUpdatingGroundSpeedData()
        }
    }
    
    func unSetup() {
        
    }
    
    func drawGroundSpeed() {
        groundSpeedLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: groundSpeedLabelHeight)
        groundSpeedLabel.contentsScale = UIScreen.main.scale
        groundSpeedLabel.font = "Tahoma" as CFTypeRef
        groundSpeedLabel.fontSize = groundSpeedLabelFontSize
        groundSpeedLabel.foregroundColor = StateColor.Normal
        addSublayer(groundSpeedLabel)
        
    }
    
    func drawAirSpeed() {
        airSpeedLabel.frame = CGRect(x: 0, y: groundSpeedLabelHeight + 10, width: bounds.width, height: airSpeedLabelHeight)
        airSpeedLabel.contentsScale = UIScreen.main.scale
        airSpeedLabel.font = "Tahoma" as CFTypeRef
        airSpeedLabel.fontSize = airSpeedLabelFontSize
        airSpeedLabel.foregroundColor = StateColor.Normal
        addSublayer(airSpeedLabel)
        
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

