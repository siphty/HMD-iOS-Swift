//
//  HMDAltitudeRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import DJISDK


class HMDAltitudeRenderer: CALayer{
    
    var didSetup = false
    var operationMode = misc.operationMode.Hover
    var zoom = 1
    var locationManager = CLLocationManager()
    var previousHomeAltitude: CGFloat = 0.0
    
    //Fixed layers
    var baroAltitudeLabel = HMDBarometricAltitudeLabelLayer()
    var radarAltitudeLabel = HMDRadarAltitudeLabelLayer()
    var homeAltitudeLabel = CATextLayer()
    var lowAltitudeScale = HMDLowAltitudeScaleLayer()
    var highAltitudeScale = HMDHighAltitudeScaleLayer()
    var altitudeScale = CALayer()
    
    //Layers with animation
//    var altitudeStick = HMDAltitudeStickLayer()
    var altitudeStick = CALayer()
    var verticalVelocityCursor = HMDVerticalVelocityCursorLayer()
    var remoteThrustCursor = HMDRemoteControllerThrustCursorLayer()
    var thrustAnimateLock = false
    
    //Default values
    var baroAltiLabelHeight = CGFloat(18)
    var baroAltiLabelFontSize = CGFloat(14)
    var radarAltiLabelHeight = CGFloat(18)
    var radarAltiLabelFontSize = CGFloat(15)
    var homeAltiLabelHeight = CGFloat(18)
    var homeAltiLabelFontSize = CGFloat(14)
    
    internal var orientation: CLDeviceOrientation = CLDeviceOrientation.landscapeRight
    {
        didSet
        {
            locationManager.headingOrientation = self.orientation
        }
    }
    
        
    func setup() {
        drawAltitudeScales()
        drawAltitudeLabels()
        drawVerticalSpeed()
        initAltitudeStick()
        switch operationMode {
        case .Home:
            registerLocationManagerDelegate()
        case .Cruise,.Hover, .Trans:
//            registerLocationManagerDelegate()
            startUpdatingAircraftAltitudeData()
            startUpdatingRemoteControllerThrustData()
            startUpdatingHomeAltitudeData()
            startUpdatingAircraftAltitudeData()
            startUpdatingAircraftVerticalVelocityData()
        case .Camera:
            startUpdatingAircraftAltitudeData()
            startUpdatingRemoteControllerThrustData()
            startUpdatingHomeAltitudeData()
            startUpdatingAircraftAltitudeData()
            startUpdatingAircraftVerticalVelocityData()
        }
    }
    
    func unSetup() {
        stopUpdatingHomeAltitudeData()
        stopUpdatingAircraftAltitudeData()
        stopUpdatingRemoteControllerThrustData()
        stopUpdatingAircraftVerticalVelocityData()
        sublayers = nil
    }
    
    func drawAltitudeLabels(){
        baroAltitudeLabel.frame = CGRect(x: 0,
                                         y: 0,
                                         width: frame.width.half(),
                                         height: baroAltiLabelHeight)
        baroAltitudeLabel.contentsScale = UIScreen.main.scale
        baroAltitudeLabel.alignmentMode = kCAAlignmentRight
        baroAltitudeLabel.font = "Tahoma" as CFTypeRef
        baroAltitudeLabel.fontSize = baroAltiLabelFontSize
        baroAltitudeLabel.foregroundColor = StateColor.Normal
        addSublayer(baroAltitudeLabel)
        
        radarAltitudeLabel.frame = CGRect(x: 0 + 10,
                                          y: (frame.height - radarAltiLabelHeight) / 2,
                                          width: frame.width.half() - 5,
                                          height: radarAltiLabelHeight)
        radarAltitudeLabel.borderColor = HMDColor.redScale
        radarAltitudeLabel.borderWidth = 1
        radarAltitudeLabel.contentsScale = UIScreen.main.scale
        radarAltitudeLabel.alignmentMode = kCAAlignmentCenter
        radarAltitudeLabel.font = "Tahoma" as CFTypeRef
        radarAltitudeLabel.fontSize = radarAltiLabelFontSize
        radarAltitudeLabel.foregroundColor = StateColor.Normal
        radarAltitudeLabel.string = "0"
        addSublayer(radarAltitudeLabel)
        
        homeAltitudeLabel.frame = CGRect(x: 0,
                                         y: frame.height - homeAltiLabelHeight,
                                         width: frame.width.half(),
                                         height: homeAltiLabelHeight)
        homeAltitudeLabel.contentsScale = UIScreen.main.scale
        homeAltitudeLabel.alignmentMode = kCAAlignmentRight
        homeAltitudeLabel.fontSize = homeAltiLabelFontSize
        homeAltitudeLabel.foregroundColor = StateColor.Normal
        addSublayer(homeAltitudeLabel)
    }
    
    func drawAltitudeScales(){
        altitudeScale.frame = CGRect(x: frame.width * 2/3 ,
                                     y: 0,
                                     width: frame.width * 1/3,
                                     height: frame.height)
        
        highAltitudeScale.frame = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: altitudeScale.frame.width * 3/8,
                                         height: altitudeScale.frame.height)
        highAltitudeScale.setup()
        altitudeScale.addSublayer(highAltitudeScale)
        
        altitudeStick.frame = CGRect(x: altitudeScale.frame.width * 3/8,
                                     y: altitudeScale.frame.height,
                                     width: altitudeScale.frame.width * 2/8,
                                     height: altitudeScale.frame.height)
        altitudeStick.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        altitudeStick.borderColor = HMDColor.redScale
        altitudeStick.borderWidth = 1
        altitudeScale.addSublayer(altitudeStick)
        
        lowAltitudeScale.frame = CGRect(x: altitudeScale.frame.width * 5/8,
                                         y: 0.0,
                                         width: altitudeScale.frame.width * 3/8,
                                         height: altitudeScale.frame.height)
        lowAltitudeScale.setup()
        altitudeScale.addSublayer(lowAltitudeScale)
                
        addSublayer(altitudeScale)
        
        altitudeScale.masksToBounds = true
        
    }
    
    func drawVerticalSpeed(){
        verticalVelocityCursor.frame = CGRect(x: frame.width * (1 - 1/3 - 1/9),
                                              y: 0.0,
                                              width: frame.width * 1/9,
                                              height: frame.height)
        verticalVelocityCursor.setup()
        addSublayer(verticalVelocityCursor)
        
        remoteThrustCursor.frame = CGRect(x: frame.width * (1 - 1/3 - 1/9),
                                              y: 0.0,
                                              width: frame.width * 1/9,
                                              height: frame.height)
        remoteThrustCursor.setup()
        addSublayer(remoteThrustCursor)
        
    }

    func initAltitudeStick(){
        altitudeStick.backgroundColor = HMDColor.redScale
        preflightCheck()
    }
    
    
    func registerLocationManagerDelegate(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestWhenInUseAuthorization()
            orientation = misc.getCLDeviceOrientation(by: UIDevice.current.orientation)
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.headingFilter = 0.1
            locationManager.headingOrientation =  orientation
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
        }
    }
    
 
    
    //Data source updating
    let aircraftAttitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamAttitude)
    let gimbalAttitudeKey = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees)
    let remoteRightHorizontalKey = DJIRemoteControllerKey(param: DJIRemoteControllerParamRightHorizontalValue)
    
    let aircraftAltitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamAltitudeInMeters)
    let aircraftUltraSonicAltitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamUltrasonicHeightInMeters)
    let aircraftUltraSonicBeingUsedKey = DJIFlightControllerKey(param: DJIFlightControllerParamIsUltrasonicBeingUsed)
    let remoteLeftVerticalKey = DJIRemoteControllerKey(param: DJIRemoteControllerParamLeftVerticalValue)
    let verticalVelocityKey = DJIFlightControllerKey(param: DJIFlightControllerParamVelocity)
    let homeAltitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamTakeoffLocationAltitude)
    
    var altitudeLock = false
    var isUltraSonicBeingUsed = false
    
    func startUpdatingAircraftAltitudeData(){
        
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftAltitudeKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                guard newValue != nil && self.isUltraSonicBeingUsed else { return }
                                                                if self.altitudeLock == true { return }
                                                                let altitudeInMeters =  newValue!.value! as! NSNumber
                                                                self.updateRadarAltitudeLabel(CGFloat(altitudeInMeters))
                                                                self.updateBarometricAltitudeLabel(CGFloat(altitudeInMeters) + CGFloat(self.previousHomeAltitude))
                                                                self.changeAltitudeStickHeight(CGFloat(altitudeInMeters))
        })
        startUpdatingUltraSonicHeight()
    }
    
    func checkUltraSonicBeingUsed() -> Bool{
        return DJISDKManager.keyManager()?.getValueFor(aircraftUltraSonicBeingUsedKey!)?.value as! Bool
    }
    
    func stopUpdatingAircraftAltitudeData(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftAltitudeKey!, ofListener: self)
        stopUpdatingUltraSonicHeight()
    }
    
    func startUpdatingUltraSonicHeight(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftUltraSonicAltitudeKey!, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
            guard newValue != nil else { return }
            let altitudeInMeters =  newValue!.value! as! NSNumber
            if Double(altitudeInMeters) > 4.9 {
                self.altitudeLock = false
            } else {
                self.altitudeLock = true
                self.updateRadarAltitudeLabel(CGFloat(altitudeInMeters))
                self.updateBarometricAltitudeLabel(CGFloat(altitudeInMeters) + CGFloat(self.previousHomeAltitude))
                self.changeAltitudeStickHeight(CGFloat(altitudeInMeters))
            }
        })
    }
    
    func stopUpdatingUltraSonicHeight(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftUltraSonicAltitudeKey!, ofListener: self)
    }
    
    func startUpdatingAircraftVerticalVelocityData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: verticalVelocityKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let velocity = newValue!.value! as! DJISDKVector3D
                                                                self.shiftVerticalVelocityCursor(CGFloat(velocity.z))
        })
    }
    func stopUpdatingAircraftVerticalVelocityData(){
        DJISDKManager.keyManager()?.stopListening(on: verticalVelocityKey!, ofListener: self)
    }
    
    func startUpdatingRemoteControllerThrustData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: remoteLeftVerticalKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let thrustValue = newValue!.value! as! NSNumber
                                                                self.shiftRemoteThrustCursor(CGFloat(thrustValue))
        })
    }
    func stopUpdatingRemoteControllerThrustData(){
        DJISDKManager.keyManager()?.stopListening(on: remoteLeftVerticalKey!, ofListener: self)
    }
    
    
    /// The home might be moved when operator walk around or drive around. The Altitudes might be different.
    func startUpdatingHomeAltitudeData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: homeAltitudeKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let altitudeInMeters =  newValue!.value! as! NSNumber
                                                                self.updateHomeAltitudeLabel(CGFloat(altitudeInMeters))
                                                                self.previousHomeAltitude = CGFloat(altitudeInMeters)
        })
    }
    func stopUpdatingHomeAltitudeData(){
        DJISDKManager.keyManager()?.stopListening(on: homeAltitudeKey!, ofListener: self)
    }
    
    
    //Animation actions
    
    func changeAltitudeStickHeight(_ altitude: CGFloat){
//        print("Altitude in meters: \(altitude)")
        var newYInPixels: CGFloat = 0.0
        if altitude < AltitudeState.low {
            newYInPixels = altitudeStick.frame.height - altitudeStick.frame.height * 1/4 * (altitude / AltitudeState.low)
            altitudeStick.backgroundColor = UIColor.yellow.cgColor
            altitudeStick.borderColor = UIColor.yellow.cgColor
        } else if AltitudeState.low ... AltitudeState.legal ~= altitude {
            newYInPixels = altitudeStick.frame.height * 3/4 - altitudeStick.frame.height * 2/4 * ((altitude - AltitudeState.low) / (AltitudeState.legal - AltitudeState.low))
            altitudeStick.backgroundColor = HMDColor.redScale
            altitudeStick.borderColor = HMDColor.redScale
        } else if AltitudeState.legal ... AltitudeState.max ~= altitude {
            newYInPixels = altitudeStick.frame.height * 1/4 - altitudeStick.frame.height * 1/4 * ((altitude - AltitudeState.legal) / (AltitudeState.max - AltitudeState.legal))
            altitudeStick.backgroundColor = UIColor.orange.cgColor
            altitudeStick.borderColor = UIColor.orange.cgColor
        } else if AltitudeState.max ... AltitudeState.serviceCeiling ~= altitude {
            newYInPixels = 0
            altitudeStick.backgroundColor = UIColor.red.cgColor
            altitudeStick.borderColor = UIColor.red.cgColor
        } else {
            newYInPixels = frame.height
        }
        
        
        CALayer.performWithAnimation({
            let animation =  CABasicAnimation(keyPath: "position")
            animation.isRemovedOnCompletion = true
            animation.fromValue = self.altitudeStick.position
            print("altitudeStick.position from: \(self.altitudeStick.position)")
            animation.toValue = CGPoint(x: self.altitudeStick.frame.origin.x,
                                        y: newYInPixels )
            self.altitudeStick.position = animation.toValue as! CGPoint
            self.altitudeStick.add(animation, forKey:  "position")
        }, completionHandler: {})
    }
    
    func updateRadarAltitudeLabel(_ altitude: CGFloat){
        if altitude < AltitudeState.low {
        } else if AltitudeState.low ... AltitudeState.serviceCeiling ~= altitude {
            let redarAltitude = String(format:"%.1f",floor(Double(altitude)))
            radarAltitudeLabel.string = redarAltitude
        }
            let redarAltitude = Int(floor(Double(altitude)))
            radarAltitudeLabel.string = "\(redarAltitude)"
        
    }
    
    func shiftVerticalVelocityCursor(_ velocity: CGFloat){
        print("Vertical velocity in meters per second: \(velocity)")
        let VerticalVelocityValueToPixel = (velocity / 5) * (frame.height / 4.0) * -1
        self.verticalVelocityCursor.position = CGPoint(x: self.verticalVelocityCursor.position.x,
                                                   y: self.frame.height.half() + VerticalVelocityValueToPixel)
        self.thrustAnimateLock = false
    }
    
    func shiftRemoteThrustCursor(_ value: CGFloat){
        print("Remote Controller Vertical velocity value: \(value)")
        let joystickMaxValue: CGFloat = 660.0
        let thrustValueToPixel = (value / joystickMaxValue) * (frame.height / 4.0) * -1
            self.remoteThrustCursor.position = CGPoint(x: self.remoteThrustCursor.position.x,
                                                       y: self.frame.height.half() + thrustValueToPixel)
    
    }
    
    func updateBarometricAltitudeLabel(_ altitude: CGFloat){
        let baroAltitude = Int(floor(Double(previousHomeAltitude + altitude)))
        baroAltitudeLabel.string = "\(baroAltitude)"
    }
    
    func updateHomeAltitudeLabel(_ altitude: CGFloat){
//        print("Home Altitude in meters: \(altitude)")
        let homeAltitude = Int(floor(Double(altitude)))
        homeAltitudeLabel.string = "\(homeAltitude)"
    }
    
    
    func preflightCheck(){
        //Altitude Stick check
//        let animation: CABasicAnimation
//        animation = CABasicAnimation(keyPath: "transform.translation.y")
//        animation.duration = 1
//        animation.repeatCount = 1
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = kCAFillModeForwards
//        animation.autoreverses = true
//        animation.fromValue = NSNumber(floatLiteral: 300)
//        animation.toValue = NSNumber(floatLiteral: 2)
//        altitudeStick.add(animation, forKey: nil)
        
        let cursorAnimation: CABasicAnimation
        cursorAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        cursorAnimation.duration = 1.5
        cursorAnimation.repeatCount = 1
        cursorAnimation.isRemovedOnCompletion = false
        cursorAnimation.fillMode = kCAFillModeForwards
        cursorAnimation.autoreverses = true
        cursorAnimation.fromValue = NSNumber(floatLiteral: 0)
        cursorAnimation.toValue = NSNumber(floatLiteral: -70)
        verticalVelocityCursor.add(cursorAnimation, forKey: nil)
    }
}

extension HMDAltitudeRenderer: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didSetup {
            return
        }
        //Initial ground altitude
        let alt = locations[0].altitude
        homeAltitudeLabel.string = String(Int(alt.rounded()))
        baroAltitudeLabel.string = String(Int(alt.rounded()))
        locationManager.stopUpdatingLocation()
        
    }
}
