//
//  HMDAltitudeRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreLocation



class HMDAltitudeRenderer: CALayer{
    
    var didSetup = false
    var zoom = 1
    var locationManager = CLLocationManager()
    var baroAltitudeLabel = HMDBarometricAltitudeLabelLayer()
    var radarAltitudeLabel = HMDRadarAltitudeLabelLayer()
    var homeAltitudeLabel = CATextLayer()
    var lowAltitudeScale = HMDLowAltitudeScaleLayer()
    var highAltitudeScale = HMDHighAltitudeScaleLayer()
    var altitudeStick = HMDAltitudeStickLayer()
    
    var verticalSpeedIndicator = HMDVerticalSpeedIndicatoerLayer()
    
    var baroAltiLabelHeight = CGFloat(20)
    var baroAltiLabelFontSize = CGFloat(14)
    var radarAltiLabelHeight = CGFloat(30)
    var radarAltiLabelFontSize = CGFloat(16)
    var homeAltiLabelHeight = CGFloat(20)
    var homeAltiLabelFontSize = CGFloat(14)
    
    internal var orientation: CLDeviceOrientation = CLDeviceOrientation.landscapeRight
    {
        didSet
        {
            locationManager.headingOrientation = self.orientation
        }
    }
    
    
    public override init() {
        super.init()
        if !didSetup {
            didSetup = true
            setup()
        }
        //TODO: I might need move all location manager to a single class
        locationManager.requestWhenInUseAuthorization()
        orientation = misc.getCLDeviceOrientation(by: UIDevice.current.orientation)
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = 0.1
        //        locationManager.headingOrientation =  CLDeviceOrientation.landscapeRight
        locationManager.headingOrientation =  orientation
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSublayers() {
        if !didSetup {
            didSetup = true
            setup()
        }
        
    }
    
    func setup() {
        drawAltitudeScale()
        drawAltitudeLabels()
        
    }
    
    func drawAltitudeScale(){
        let altitudeScale = CALayer()
        altitudeScale.frame = CGRect(x: frame.width.middle(),
                                     y: 0,
                                     width: frame.width.half(),
                                     height: frame.height)
        altitudeScale.borderColor = UIColor.red.cgColor
        altitudeScale.borderWidth = 1
        
    }
    
    
    func drawAltitudeLabels(){
        baroAltitudeLabel.frame = CGRect(x: 0,
                                         y: 0,
                                         width: frame.width.half(),
                                         height: baroAltiLabelHeight)
        baroAltitudeLabel.contentsScale = UIScreen.main.scale
        baroAltitudeLabel.font = "Tahoma" as CFTypeRef
        baroAltitudeLabel.fontSize = baroAltiLabelFontSize
        baroAltitudeLabel.borderWidth = 1
        baroAltitudeLabel.borderColor = UIColor.yellow.cgColor
        addSublayer(baroAltitudeLabel)
        
        radarAltitudeLabel.frame = CGRect(x: 0,
                                          y: (frame.height - radarAltiLabelHeight) / 2,
                                          width: frame.width.half(),
                                          height: radarAltiLabelHeight)
        radarAltitudeLabel.contentsScale = UIScreen.main.scale
        radarAltitudeLabel.font = "Tahoma" as CFTypeRef
        radarAltitudeLabel.fontSize = radarAltiLabelFontSize
        radarAltitudeLabel.borderWidth = 1
        radarAltitudeLabel.borderColor = UIColor.magenta.cgColor
        radarAltitudeLabel.string = "0"
        addSublayer(radarAltitudeLabel)
        
        homeAltitudeLabel.frame = CGRect(x: 0,
                                         y: frame.height - homeAltiLabelHeight,
                                         width: frame.width.half(),
                                         height: homeAltiLabelHeight)
        homeAltitudeLabel.contentsScale = UIScreen.main.scale
        homeAltitudeLabel.fontSize = homeAltiLabelFontSize
        homeAltitudeLabel.foregroundColor = stateColor.Normal
        homeAltitudeLabel.borderWidth = 1
        homeAltitudeLabel.borderColor = UIColor.orange.cgColor
        addSublayer(homeAltitudeLabel)
    }

}

extension HMDAltitudeRenderer: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !didSetup {
            return
        }
        let alt = locations[0].altitude
        homeAltitudeLabel.string = String(Int(alt.rounded()))
        baroAltitudeLabel.string = String(Int(alt.rounded()))
        locationManager.stopUpdatingLocation()
    }
}
