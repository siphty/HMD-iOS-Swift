//
//  HMDAttitudeRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation
import DJISDK


class HMDAttitudeRenderer: CALayer {
    
    //Configuration
    var didSetup = false
    var operationMode = misc.operationMode.Hover
    var locationManager = CLLocationManager()
    var motionManager = CMMotionManager()
    
    //Spin layers group
    var spinLayer = CALayer()
    var gimbalAttiSpinLayer = CALayer()
    var aircraftAttiSpinLayer = CALayer()
    var bankScale = HMDBankScaleLayer()
    var pitchLadder = HMDPitchLadderLayer()
    var centreDatum = HMDCentreDatumLayer()
    var aircraftRollCursor = HMDAircraftRollCursorLayer()
    var aircraftReference = HMDAircraftReferenceLayer()
    
    //Fixed Layers
    var sideslip = HMDSideslipLayer()
    var hoverVector = CAShapeLayer()
    var viewAreaReference = CALayer()
    
    var previousGimbalAttitudeRollDegree : CGFloat = 0.0

    internal var orientation: CLDeviceOrientation = CLDeviceOrientation.landscapeRight
    {
        didSet
        {
            locationManager.headingOrientation = self.orientation
        }
    }
    
    func setup () {
        gimbalAttiSpinLayer.frame = bounds //.getScale(by: 0.9)
        bankScale.frame = gimbalAttiSpinLayer.bounds
        bankScale.setup()
        gimbalAttiSpinLayer.addSublayer(bankScale)
        pitchLadder.bounds = CGRect(x: 0, y: 0, width: spinLayer.bounds.width, height: 200 * 10.48)
        pitchLadder.position = CGPoint(x: gimbalAttiSpinLayer.bounds.width.middle(), y: gimbalAttiSpinLayer.bounds.height.middle())
        pitchLadder.setup()
        aircraftReference.bounds = CGRect(x: 0, y: 0, width: pitchLadder.bounds.width.half(), height: pitchLadder.bounds.width.half())
        aircraftReference.position = CGPoint(x: pitchLadder.bounds.width.half(), y: pitchLadder.bounds.height.half())
        aircraftReference.setup()
        pitchLadder.addSublayer(aircraftReference)
        gimbalAttiSpinLayer.addSublayer(pitchLadder)
        addSublayer(gimbalAttiSpinLayer)
        
        aircraftAttiSpinLayer.frame = bounds
        aircraftRollCursor.frame = aircraftAttiSpinLayer.frame
        aircraftRollCursor.setup()
        aircraftAttiSpinLayer.addSublayer(aircraftRollCursor)
        addSublayer(aircraftAttiSpinLayer)
        
        centreDatum.frame = bounds
        centreDatum.setup()
        addSublayer(centreDatum)
        
        
        switch operationMode {
        case misc.operationMode.Home:
            locationManager.requestWhenInUseAuthorization()
            orientation = misc.getCLDeviceOrientation(by: UIDevice.current.orientation)
            locationManager.headingOrientation =  orientation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.headingFilter = 0.1
            locationManager.startUpdatingHeading()
//            locationManager.delegate = self
            
            motionManager.accelerometerUpdateInterval = 0.01
        case misc.operationMode.Hover, misc.operationMode.Cruise, misc.operationMode.Trans:
//            let aircraft = DJISDKManager.product() as? DJIAircraft
//            aircraft?.gimbal?.delegate = self
            //            aircraft?.flightController?.delegate = self
            startUpdatingGimbalAttitude()
            startUpdatingAircraftAttitude()
            startUpdateRemoteRightHorizontal()
        }
        
    }
    
    func unSetup() {
        stopUpdatingAircraftAttitude()
        stopUpdatingGimbalHeadingData()
        stopUpdateRemoteRightHorizontal()
        sublayers = nil
    }
    
    //Draw detail components
//    func drawAircraftRollCursor() -> CALayer {
//        
//    }
    
    
    let aircraftAttitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamAttitude)
    let gimbalAttitudeKey = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees)
    let remoteRightHorizontalKey = DJIRemoteControllerKey(param: DJIRemoteControllerParamRightHorizontalValue)
    
    //Data source updating
    func startUpdatingAircraftAttitude(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftAttitudeKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
//                                                                print("aircraftAttitude: \(newValue.debugDescription)")
                                                                let attitude = newValue!.value! as! DJISDKVector3D
                                                                var AircraftRollDegree = CGFloat(attitude.x)
                                                                let AircraftPitchDegree = CGFloat(attitude.y)
                                                                if AircraftRollDegree < 0 {
                                                                    AircraftRollDegree = 360 + AircraftRollDegree
                                                                }
                                                                var rollingDifference = AircraftRollDegree - self.previousGimbalAttitudeRollDegree
                                                                if rollingDifference > 180 {
                                                                    rollingDifference = rollingDifference - 360
                                                                }
//                                                                print(" body to roll degree: \(rollingDifference)")
                                                                self.spinAircraftAttitudeLayer(angle: rollingDifference)
                                                                self.moveAircraftReference(byRoll: AircraftRollDegree,
                                                                                           pitch: AircraftPitchDegree)
        })
    }
    
    func stopUpdatingAircraftAttitude(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftAttitudeKey!, ofListener: self)
    }
    
    func startUpdatingGimbalAttitude(){
        DJISDKManager.keyManager()?.startListeningForChanges(on:gimbalAttitudeKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                var attitudeInDegrees = DJIGimbalAttitude()
                                                                let theNewValue = newValue!.value! as! NSValue
                                                                theNewValue.getValue(&attitudeInDegrees)
                                                                self.previousGimbalAttitudeRollDegree = CGFloat(attitudeInDegrees.roll)
//                                                                print("gimbal roll: \(attitudeInDegrees.roll)")
                                                                self.spinGimbalAttitudeLayer(angle: CGFloat(attitudeInDegrees.roll))
//                                                                print("gimbal pitch: \(attitudeInDegrees.pitch)")
                                                                self.shiftGimbalAttitudePitchLadder(angle: CGFloat(attitudeInDegrees.pitch))
        })
    }
    
    func stopUpdatingGimbalHeadingData(){
        DJISDKManager.keyManager()?.stopListening(on: gimbalAttitudeKey!, ofListener: self)
    }

    func startUpdateRemoteRightHorizontal(){
            DJISDKManager.keyManager()?.startListeningForChanges(on: remoteRightHorizontalKey!,
                                                                 withListener: self,
                                                                 andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                    if newValue == nil {
                                                                        return
                                                                    }
                                                                    let sideSliperValue = newValue!.value! as! NSNumber
                                                                    self.moveSidesliperCursor(to: sideSliperValue)
            })
    }
    
    func stopUpdateRemoteRightHorizontal(){
        DJISDKManager.keyManager()?.stopListening(on: remoteRightHorizontalKey!, ofListener: self)
    }
    
    // Animation actions
    func spinAircraftAttitudeLayer(angle degrees: CGFloat){
            let radians = self.degree2radian(degrees)
            self.aircraftAttiSpinLayer.transform = CATransform3DMakeRotation(radians * -1, 0.0, 0.0, 1.0)
    }
    
    func spinGimbalAttitudeLayer(angle degrees: CGFloat){
            let radians = self.degree2radian(degrees)
            self.gimbalAttiSpinLayer.transform = CATransform3DMakeRotation(radians * -1, 0.0, 0.0, 1.0)
    }
    
    func shiftGimbalAttitudePitchLadder(angle degrees: CGFloat){
//        print("Pitch Ladder moving to : \(degrees)")
        let shiftPicels = UIConf.pixelPerUnit * degrees
            let yPosition = self.aircraftAttiSpinLayer.position.y + shiftPicels
            self.pitchLadder.position = CGPoint(x: self.pitchLadder.position.x, y : yPosition )
    }
    
    func moveAircraftReference(byRoll rollDegree: CGFloat, pitch pitchDegree: CGFloat){
        
        let shiftPicels = UIConf.pixelPerUnit * pitchDegree * -1
            let yPosition = self.pitchLadder.frame.height.half() + shiftPicels
            self.aircraftReference.position = CGPoint(x: self.pitchLadder.frame.width.half(), y : yPosition )

            let radians = self.degree2radian(rollDegree)
            self.aircraftReference.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)

    }
    
    func moveSidesliperCursor(to sideSliperValue:NSNumber){
        
        print("\(sideSliperValue)")
    }
    
    func degree2radian(_ degree:CGFloat) -> CGFloat {
        let radian = CGFloat(Double.pi) * degree/180
        return radian
    }
}




extension HMDAttitudeRenderer: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
        print("LM Delegate by HMDAttitudeRenderer")
        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
    }
    
    
}

