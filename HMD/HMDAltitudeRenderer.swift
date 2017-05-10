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
    
    //Fixed layers
    var baroAltitudeLabel = HMDBarometricAltitudeLabelLayer()
    var radarAltitudeLabel = HMDRadarAltitudeLabelLayer()
    var homeAltitudeLabel = CATextLayer()
    var lowAltitudeScale = HMDLowAltitudeScaleLayer()
    var highAltitudeScale = HMDHighAltitudeScaleLayer()
    
    //Layers with animation
//    var altitudeStick = HMDAltitudeStickLayer()
    var altitudeStick = CALayer()
    var verticalSpeedIndicator = HMDVerticalSpeedIndicatorLayer()
    
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
    
    
    public override init() {
        super.init()
//        if !didSetup {
//            didSetup = true
//            setup()
//        }
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
        drawAltitudeScales()
        drawAltitudeLabels()
        drawVerticalSpeed()
        initAltitudeStick()
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
        radarAltitudeLabel.borderColor = UIColor.hmdGreen.cgColor
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
        let altitudeScale = CALayer()
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
                                     y: 0.0,
                                     width: altitudeScale.frame.width * 2/8,
                                     height: altitudeScale.frame.height)
        altitudeStick.borderColor = UIColor.green.cgColor
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
        verticalSpeedIndicator.frame = CGRect(x: frame.width * (1 - 1/3 - 1/9),
                                              y: 0.0,
                                              width: frame.width * 1/9,
                                              height: frame.height)
        verticalSpeedIndicator.setup()
        addSublayer(verticalSpeedIndicator)
    }

    func initAltitudeStick(){
        altitudeStick.backgroundColor = UIColor.hmdGreen.cgColor
        CALayer.performAnimation(within: 10.0,
                                 action: {
//                                    let altFrame = self.altitudeStick.frame
//                                    self.altitudeStick.frame = CGRect(x: altFrame.origin.x,
//                                                                      y: altFrame.height - 10,
//                                                                      width: altFrame.width,
//                                                                      height: 10)
                                    
                                    let animation = CABasicAnimation(keyPath: "transform")
                                    animation.duration = 5
                                    animation.fromValue = CATransform3DIdentity
                                    animation.toValue = CATransform3DMakeScale(1.0, 0.5, 1.0)
                                    animation.isRemovedOnCompletion = false
                                    self.altitudeStick.add(animation, forKey: "transform")
                                    
//                                    animation.fillMode = kCAFillModeForwards
//                                    animation.isRemovedOnCompletion = true
//                                    let altFrame = self.altitudeStick.frame
//                                    animation.fromValue = self.altitudeStick.frame//position
//                                    animation.toValue = CGRect(x: altFrame.origin.x,
//                                                               y: altFrame.height - 10,
//                                                               width: altFrame.width,
//                                                               height: 10)
//                                    animation.toValue = CGPoint(x: 0.0,
//                                                                y: self.altitudeStick.frame.height + self.altitudeStick.position.y)
//                                    animation.isRemovedOnCompletion = false
//                                    self.altitudeStick.add(animation, forKey: "transform")
        },completionHandler: {
//            self.altitudeStick.position = CGPoint(x: 0.0,
//                                                  y: self.altitudeStick.frame.height + self.altitudeStick.position.y)
            print("animation finished")
        })
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
