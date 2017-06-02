//
//  HMDHeadingRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreLocation
import DJISDK

class HMDHeadingRenderer: CALayer {
    
    //Configuration
    var didSetup = false
    //TODO: fix the initial default problem of operationMode
    public var operationMode = misc.operationMode.Hover
    var translation: CGFloat = 0.0
    var locationManager = CLLocationManager()
    var pixelPerUnit: CGFloat = 10.48
    
    //Layers
    let middleLayer = CALayer()
    var scrollLayer = CALayer()
    var lastScrollLayerPostion: CGPoint = CGPoint(x: 0, y: 0)
    var lastHeadingDegree: CLLocationDirection = 0.0
    var enableLoop: Bool = true
    var enableVertical: Bool = false
    var headingScaleNorth = HMDHeadingScaleLayer()
    var headingScaleSouth = HMDHeadingScaleLayer() // I need change this someway somehow
    var aircraftHeadingCursor = HMDHeadingCursorLayer()
    let headingLabel = CATextLayer()
    var aircraftCursor = CATextLayer()
    var homeCursor = CATextLayer()
    
    var previousGimbalHeadingDegree: CGFloat = 0.0
    
    var didInitCompass = false
    var headingNumberWidth: CGFloat = 30.0
    var scrollLock = false
    let concurrentQueue = DispatchQueue(label: "updateHeading", attributes: .concurrent)
    
    internal var labelFontSize = CGFloat(12.0)
    let scaleColor = UIColor.init(red: 35.0 / 255.0, green: 210.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor
    
    
    internal var orientation: CLDeviceOrientation = CLDeviceOrientation.landscapeRight
    {
        didSet
        {
            locationManager.headingOrientation = self.orientation
        }
    }
    
    
//    public override init(){
//        super.init()
//    }
//    
//    public init(_ mode: misc.operationMode){
//        super.init()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func layoutSublayers() {
//        if !didSetup {
//            didSetup = true
//            setup()
//        }
//    }
        
    func setup () {
        switch operationMode {
        case misc.operationMode.Home:
            locationManager.requestWhenInUseAuthorization()
            orientation = misc.getCLDeviceOrientation(by: UIDevice.current.orientation)
            locationManager.headingOrientation =  orientation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.headingFilter = 0.1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        case misc.operationMode.Hover, misc.operationMode.Cruise, misc.operationMode.Trans:
            startUpdatingAircraftHeadingData()
            startUpdatingGimbalHeadingData()
        }
        
        middleLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: 31)
        
        scrollLayer = {
            let scrollLayer = CALayer()
            scrollLayer.frame = CGRect(x: 0.0, y: 0.0, width: pixelPerUnit * 360.0, height: middleLayer.frame.height)
            
            headingScaleNorth.isFacingNorth = true
            headingScaleNorth.backgroundColor = UIColor.clear.cgColor
            headingScaleNorth.frame = scrollLayer.bounds
            headingScaleNorth.labelFontSize = labelFontSize
            headingScaleNorth.setup()
            scrollLayer.addSublayer(headingScaleNorth)
            
            headingScaleSouth.isFacingNorth = false
            headingScaleSouth.backgroundColor = UIColor.clear.cgColor
            headingScaleSouth.frame = scrollLayer.bounds
            headingScaleNorth.labelFontSize = labelFontSize
            headingScaleSouth.setup()
            scrollLayer.addSublayer(headingScaleSouth)
            
            headingScaleNorth.isHidden = false
            headingScaleSouth.isHidden = true
            scrollLayer.backgroundColor = UIColor.clear.cgColor
            
            return scrollLayer
        }()
        middleLayer.addSublayer(scrollLayer)
        addSublayer(middleLayer)
        
        //Draw Heading Number Lable
        let headingNumberFrame = CGRect(x: (frame.width - headingNumberWidth) / 2,
                                        y: 0,
                                        width: headingNumberWidth,
                                        height: 14)
        middleLayer.doMask(withRect: headingNumberFrame, inverse: true)
        headingLabel.font = "Tahoma" as CFTypeRef
        headingLabel.fontSize = labelFontSize
        headingLabel.contentsScale = UIScreen.main.scale
        headingLabel.frame = headingNumberFrame
        headingLabel.borderColor = scaleColor
        headingLabel.borderWidth = 1
        headingLabel.alignmentMode = kCAAlignmentCenter
        headingLabel.foregroundColor = scaleColor
        addSublayer(headingLabel)
        
        //Draw aircraft heading
        aircraftHeadingCursor.frame = CGRect(x: 0, y: middleLayer.frame.height, width: frame.width, height: frame.height - middleLayer.frame.height)
        aircraftHeadingCursor.setup()
        aircraftHeadingCursor.backgroundColor = UIColor.clear.cgColor
        addSublayer(aircraftHeadingCursor)
        
        //Draw current view heading line
        let startPoint = CGPoint(x: frame.width / 2, y: middleLayer.frame.height)
        let endPoint = CGPoint(x: frame.width / 2, y: frame.height)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 2)
        
        //Draw Home / aircraft direction cursor
        homeCursor.frame = CGRect(x: 0, y: middleLayer.frame.height, width: frame.height - middleLayer.frame.height, height: frame.height - middleLayer.frame.height)
        homeCursor.font = "Tahoma" as CFTypeRef
        homeCursor.fontSize = 9
        homeCursor.contentsScale = UIScreen.main.scale
        homeCursor.alignmentMode = kCAAlignmentCenter
        homeCursor.foregroundColor = scaleColor
        homeCursor.string = "H"
        homeCursor.withCircleFrame()
        
        aircraftCursor.frame = CGRect(x: 30, y: middleLayer.frame.height, width: frame.height - middleLayer.frame.height, height: frame.height - middleLayer.frame.height)
        aircraftCursor.font = "Tahoma" as CFTypeRef
        aircraftCursor.fontSize = 9
        aircraftCursor.contentsScale = UIScreen.main.scale
        aircraftCursor.alignmentMode = kCAAlignmentCenter
        aircraftCursor.foregroundColor = scaleColor
        aircraftCursor.string = "A"
        aircraftCursor.withCircleFrame()
        
        addSublayer(homeCursor)
        addSublayer(aircraftCursor)
        switch operationMode {
        case .Home:
            addSublayer(aircraftCursor)
            homeCursor.removeFromSuperlayer()
        case .Cruise,.Hover, .Trans:
            addSublayer(homeCursor)
            aircraftCursor.removeFromSuperlayer()
            startUpdatingAircraftHeadingData()
            startUpdatingGimbalHeadingData()
        }
    }
    
    func unSetup(){
        stopUpdatingGimbalHeadingData()
        stopUpdatingAircraftHeadingData()
        stopUpdatingPhoneHeadingData()
        sublayers = nil
    }
    
    
    //Headings and Attitude data source
//    let aircraftHeadingKey = DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading)
    let aircraftAttitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamAttitude)
    let gimbalAttitudeKey = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees)
    
    func startUpdatingAircraftHeadingData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftAttitudeKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
//                                                                print("aircraftAttitude: \(newValue.debugDescription)")
                                                                let attitude = newValue!.value! as! DJISDKVector3D
                                                                var bodyHeadingDegree = CGFloat(attitude.z)
                                                                if bodyHeadingDegree < 0 {
                                                                    bodyHeadingDegree = 360 + bodyHeadingDegree
                                                                }
                                                                var headingDifference = self.previousGimbalHeadingDegree - bodyHeadingDegree
                                                                if headingDifference > 180 {
                                                                    headingDifference = headingDifference - 360
                                                                }
//                                                                print(" body to gimbal degree: \(headingDifference)")
                                                                self.shiftAircraftHeadingCursor(headingDifference)
        })
    }
    func stopUpdatingAircraftHeadingData(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftAttitudeKey!, ofListener: self)
    }
    
    func startUpdatingGimbalHeadingData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on:gimbalAttitudeKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                var attitudeInDegrees = DJIGimbalAttitude()
//                                                                print("gimbalAttitude: \(newValue!.value.debugDescription)")
                                                                let theNewValue = newValue!.value! as! NSValue
                                                                theNewValue.getValue(&attitudeInDegrees)
                                                                var gimbalHeadingDegree = CGFloat(attitudeInDegrees.yaw)
                                                                if gimbalHeadingDegree < 0 {
                                                                    gimbalHeadingDegree = 360 + gimbalHeadingDegree
                                                                }
                                                                self.previousGimbalHeadingDegree = gimbalHeadingDegree
                                                                self.scrollHeadingTape(with: gimbalHeadingDegree)
//                                                                print("gimbalAttitude: \(newValue.debugDescription)")
        })
    }
    func stopUpdatingGimbalHeadingData(){
        DJISDKManager.keyManager()?.stopListening(on: gimbalAttitudeKey!, ofListener: self)
    }
    
    func startUpdatingPhoneHeadingData(){

    }
    
    func stopUpdatingPhoneHeadingData(){
        
    }

    
    func scrollHeadingTape(with gimbalHeadingDegree:CGFloat) {
        var headingDegree: CGFloat
        if gimbalHeadingDegree < 0 {
            headingDegree = 360.0 + gimbalHeadingDegree
        } else {
            headingDegree = gimbalHeadingDegree
        }
        var headingPointX: CGFloat = 0.0
        //        DispatchQueue.main.async(execute: {
        //            print("Heading : \(headingDegree)")
        if self.scrollLock {
            return
        }
        self.scrollLock = true
        if !self.didInitCompass {
            
            self.locationManager.requestWhenInUseAuthorization()
            switch headingDegree {
            case 0 ... 90:
                fallthrough
            case 270 ... 360:
                
                //Facing North//
                self.headingScaleNorth.isHidden = false
                self.headingScaleSouth.isHidden = true
                headingPointX = ((headingDegree + 180).truncatingRemainder(dividingBy: 360.0)) * self.pixelPerUnit * -1 + self.middleLayer.frame.width / 2
                self.scrollLayer.frame = CGRect(x: headingPointX,
                                                y: 0,
                                                width: self.scrollLayer.frame.width,
                                                height: self.scrollLayer.frame.height)
            case 90 ... 270:
                
                //Facing South//
                self.headingScaleSouth.isHidden = false
                self.headingScaleNorth.isHidden = true
                headingPointX = headingDegree * self.pixelPerUnit * -1 + self.middleLayer.frame.width / 2
                self.scrollLayer.frame = CGRect(x: headingPointX,
                                                y : 0,
                                                width: self.scrollLayer.frame.width,
                                                height: self.scrollLayer.frame.height)
            default:
                print("Something is wrong")
            }
            self.didInitCompass = true
        } else {
            
            //Draw
            switch headingDegree {
            case 0 ... 2 :
                fallthrough
            case 358 ... 360:
                self.headingLabel.string = "N"
            case 88 ... 92:
                self.headingLabel.string = "E"
            case 178 ... 182:
                self.headingLabel.string = "S"
            case 268 ... 272:
                self.headingLabel.string = "W"
            default:
                self.headingLabel.string = String(Int(floor(headingDegree)))
            }
            if self.headingScaleSouth.isHidden {
                //Facing North
                if 150.0 ... 210.0 ~= headingDegree  {
                    //But, turning to South
                    headingPointX = headingDegree * self.pixelPerUnit * -1 + self.middleLayer.frame.width / 2
                    self.headingScaleNorth.isHidden = true
                    self.headingScaleSouth.isHidden = false
                } else {
                    //Still facing North
                    self.headingScaleNorth.isHidden = false
                    self.headingScaleSouth.isHidden = true
                    headingPointX = ((headingDegree + 180).truncatingRemainder(dividingBy: 360.0)) * self.pixelPerUnit * -1 + self.middleLayer.frame.width / 2
                }
            } else {
                //Facing South
                if 0.0 ... 30.0 ~= headingDegree || 330.0 ... 360.0 ~= headingDegree {
                    //But, turning to North
                    headingPointX = ((headingDegree + 180).truncatingRemainder(dividingBy: 360.0)) * self.pixelPerUnit * -1 + self.middleLayer.frame.width / 2
                    self.headingScaleNorth.isHidden = false
                    self.headingScaleSouth.isHidden = true
                } else {
                    //Still facing South
                    self.headingScaleNorth.isHidden = true
                    self.headingScaleSouth.isHidden = false
                    headingPointX = headingDegree * self.pixelPerUnit * -1 + self.middleLayer.frame.width / 2
                }
            }
                self.scrollLayer.frame = CGRect(x: headingPointX,
                                                y: 0,
                                                width: self.scrollLayer.frame.width,
                                                height: self.scrollLayer.frame.height)
                self.scrollLock = false
//            })
            
        }
    }
    
    func shiftAircraftHeadingCursor(_ headingDifference: CGFloat){
            self.aircraftHeadingCursor.position = CGPoint(x: (self.frame.width / 2) - headingDifference * self.pixelPerUnit,
                                                      y: self.aircraftHeadingCursor.position.y)
    }
    
    //TODO: Update home direction based on drone location and given home location.
    //TODO: Animate home cursor
    
}


extension HMDHeadingRenderer: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingDegree = CGFloat(newHeading.trueHeading)
        scrollHeadingTape(with: headingDegree)
    }
    
    
}




