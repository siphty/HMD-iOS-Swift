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
    var bankScale = HMDBankScaleLayer()
    var pitchLadder = HMDPitchLadderLayer()
    var aircraftReference = CALayer()
    var centreDatum = HMDCentreDatumLayer()
    
    //Fixed Layers
    var visualCentreDatum = CALayer() //Camera (iPhone/Drone) visual centre datum 摄像头中心基准线
    var sideslip = HMDSideslipLayer()
    var hoverVector = CAShapeLayer()
    var viewAreaReference = CALayer()

    internal var orientation: CLDeviceOrientation = CLDeviceOrientation.landscapeRight
    {
        didSet
        {
            locationManager.headingOrientation = self.orientation
        }
    }
    
    func setup () {
        spinLayer.frame = bounds //.getScale(by: 0.9)
        
        bankScale.frame = spinLayer.bounds
        bankScale.setup()
        spinLayer.addSublayer(bankScale)
        
        pitchLadder.bounds = CGRect(x: 0, y: 0, width: spinLayer.bounds.width, height: 200 * 10.48)
        pitchLadder.position = CGPoint(x: spinLayer.bounds.width.middle(), y: spinLayer.bounds.height.middle())
        pitchLadder.setup()
        spinLayer.addSublayer(pitchLadder)
        
        addSublayer(spinLayer)
        
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
            locationManager.delegate = self
            
            motionManager.accelerometerUpdateInterval = 0.01
        case misc.operationMode.Hover, misc.operationMode.Cruise, misc.operationMode.Trans:
            let aircraft = DJISDKManager.product() as? DJIAircraft
            aircraft?.gimbal?.delegate = self
            aircraft?.flightController?.delegate = self
        }
        
    }
    
}


extension HMDAttitudeRenderer: DJIGimbalDelegate{
    func gimbal(_ gimbal: DJIGimbal, didUpdate state: DJIGimbalState) {

        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
        print("Gimbal Delegate by HMDAttitudeRenderer BBBBBBB")
        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
    }
}

extension HMDAttitudeRenderer: DJIFlightControllerDelegate{
    func flightController(_ fc: DJIFlightController, didUpdate state: DJIFlightControllerState) {

        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
        print("FC Delegate by HMDAttitudeRenderer BBBBBBB")
        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
    }
}


extension HMDAttitudeRenderer: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
        print("LM Delegate by HMDAttitudeRenderer")
        print("BBBBBBBBBBBBBBBBBBBBBBBBB")
    }
    
    
}

