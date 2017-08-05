//
//  HMDLineOfSightRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 27/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit


class HMDLineOfSightRenderer: CALayer {
    var sightBox = CALayer()
    
    
    var didSetup = false
    var operationMode = misc.operationMode.Hover
    var previousGimbalAttitudeRollDegree: CGFloat = 0.0
    var previousGimbalAttitudePitchDegree: CGFloat = 0.0
    var previousGimbalAttitudeHeadingDegree: CGFloat = 0.0
    var previousAircraftHeadingDegree: CGFloat?
    
    let gimbalAttitudeKey = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees)
    let aircraftAttitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamAttitude)
    
    let cameraViewHightDegree: CGFloat = 40.86
    let cameraViewWidthDegree: CGFloat = 94.00
    var heightPixelPerDegree: CGFloat = 0.0
    var widthPixelPerDegree: CGFloat = 0.0
    
    var sightBoxOriginPosition: CGPoint?
    
    func setup() {
        borderColor = HMDColor.redScale
        borderWidth = 2

        drawSightBox()
        startUpdatingGimbalAttitude()
        startUpdatingAircraftHeadingData()
    }

    
    func unSetup() {
        stopUpdatingGimbalHeadingData()
        stopUpdatingAircraftHeadingData()
    }
    
    func drawSightBox() {
        //Camera 94.5/2 : 40.86
        //Gimble X : 120
        //SightField 360 : 140.86
        heightPixelPerDegree = bounds.height / (120 + cameraViewHightDegree)
        widthPixelPerDegree = bounds.width / 360
        let cameraVsFieldWidthProportion: CGFloat = cameraViewWidthDegree / 360.0   //  94.5 / 360
        let cameraVsFieldHeightProportion: CGFloat = cameraViewHightDegree / (120.0 + cameraViewHightDegree)  //  40.86 / 160.86
        let sightBoxFrameHeight = bounds.height * cameraVsFieldHeightProportion
        let sightBoxFrameWidth = bounds.width * cameraVsFieldWidthProportion
        let sightBoxOriginX = bounds.width.middle()
        let sightBoxOriginY = 30.0 * heightPixelPerDegree + sightBoxFrameHeight.half()
        sightBox.bounds = CGRect(x: 0, y: 0, width: sightBoxFrameWidth, height: sightBoxFrameHeight)
        sightBox.borderColor = HMDColor.redScale
        sightBox.borderWidth = 1
        sightBox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sightBoxOriginPosition = sightBox.position
        sightBox.position = CGPoint(x: sightBoxOriginX, y: sightBoxOriginY)
        sightBoxOriginPosition = sightBox.position
        let positionDot = CALayer()
        positionDot.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 2, height: 2))
        positionDot.backgroundColor = UIColor.red.cgColor
        positionDot.borderColor = positionDot.backgroundColor
        positionDot.borderWidth = 1
        positionDot.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        positionDot.position = CGPoint(x: sightBox.bounds.width.middle(), y: sightBox.bounds.height.middle())
        positionDot.shadowColor = LayerShadow.Color
        positionDot.shadowOffset = LayerShadow.Offset
        positionDot.shadowRadius = LayerShadow.Radius
        positionDot.shadowOpacity = LayerShadow.Opacity
        sightBox.addSublayer(positionDot)
        addSublayer(sightBox)
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
                                                                self.previousGimbalAttitudePitchDegree = CGFloat(attitudeInDegrees.pitch)
                                                                self.previousGimbalAttitudeHeadingDegree = CGFloat(attitudeInDegrees.yaw)
                                                                
                                                                self.moveLineOfSightBox(by: attitudeInDegrees)
                                                                
                                                                
        })
    }
    
    func stopUpdatingGimbalHeadingData(){
        DJISDKManager.keyManager()?.stopListening(on: gimbalAttitudeKey!, ofListener: self)
    }
    
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
                                                                self.previousAircraftHeadingDegree = bodyHeadingDegree
        })
    }
    func stopUpdatingAircraftHeadingData(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftAttitudeKey!, ofListener: self)
    }
    
    func moveLineOfSightBox(by attitude: DJIGimbalAttitude) {
        CALayer.performWithAnimation({
            guard self.previousAircraftHeadingDegree != nil else { return }
            var headingDifference: CGFloat = self.previousGimbalAttitudeHeadingDegree - self.previousAircraftHeadingDegree!
            if headingDifference > 180 {
                headingDifference = headingDifference - 360
            } else if headingDifference < -180{
                headingDifference = headingDifference + 360
            }
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = self.sightBox.position
//            print("sight box position: \(self.sightBox.position)")
            let yawPixel = headingDifference * widthPixelPerDegree + sightBoxOriginPosition!.x
            let pitchPixel = CGFloat(attitude.pitch - 30.0) * heightPixelPerDegree * -1 + sightBox.bounds.height.half()
            animation.toValue = CGPoint(x: yawPixel, y: pitchPixel)
            sightBox.add(animation, forKey: "position")
            sightBox.position = animation.toValue as! CGPoint
        }, completionHandler: {})
    }
    
    
    
    
    
    
    
    
    
    
}
