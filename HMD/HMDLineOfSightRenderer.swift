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
    var previousAircraftHeadingDegree: CGFloat = 0.0
    
    let gimbalAttitudeKey = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees)
    let aircraftAttitudeKey = DJIFlightControllerKey(param: DJIFlightControllerParamAttitude)
    
    let cameraViewHightDegree: CGFloat = 40.86
    let cameraViewWidthDegree: CGFloat = 94.00
    var heightDegreeToPixels: CGFloat = 0.0
    var widthDegreeToPixels: CGFloat = 0.0
    
    func setup() {
        borderColor = HMDColor.scale
        borderWidth = 2

        drawSightBox()
        startUpdatingGimbalAttitude()
    }

    
    func unSetup() {
        stopUpdatingGimbalHeadingData()
    }
    
    func drawSightBox() {
        //Camera 94.5/2 : 40.86
        //Gimble X : 120
        //SightField 360 : 140.86
        heightDegreeToPixels = bounds.height / (120 + cameraViewHightDegree)
        widthDegreeToPixels = bounds.width / 360
        let cameraVsFieldWidthProportion: CGFloat = cameraViewWidthDegree / 360.0   //  94.5 / 360
        let cameraVsFieldHeightProportion: CGFloat = cameraViewHightDegree / (120.0 + cameraViewHightDegree)  //  40.86 / 160.86
        let sightBoxFrameHeight = bounds.height * cameraVsFieldHeightProportion
        let sightBoxFrameWidth = bounds.width * cameraVsFieldWidthProportion
        let sightBoxOriginX = bounds.width.middle() - sightBoxFrameWidth.half()
        let sightBoxOriginY = bounds.height * 0.25 - sightBoxFrameHeight.half()
        sightBox.frame = CGRect(x: sightBoxOriginX, y: sightBoxOriginY, width: sightBoxFrameWidth, height: sightBoxFrameHeight)
        sightBox.borderColor = HMDColor.scale
        sightBox.borderWidth = 1
        sightBox.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
            var headingDifference: CGFloat = self.previousGimbalAttitudeHeadingDegree - self.previousAircraftHeadingDegree
            if headingDifference > 180 {
                headingDifference = headingDifference - 360
            }
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = self.sightBox.position
            print("sight box position: \(self.sightBox.position)")
            let yawPixel = headingDifference * widthDegreeToPixels + bounds.width.middle()
            let pitchPixel = CGFloat(attitude.pitch - 30.0) * heightDegreeToPixels * -1 + sightBox.bounds.width.middle()
            animation.toValue = CGPoint(x: yawPixel, y: pitchPixel)
            sightBox.add(animation, forKey: "position")
            sightBox.position = animation.toValue as! CGPoint
        }, completionHandler: {})
    }
    
    
    
    
    
    
    
    
    
    
}
