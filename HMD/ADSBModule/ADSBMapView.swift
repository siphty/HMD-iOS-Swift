//
//  ADSBMapView.swift
//  HMD
//
//  Created by Yi JIANG on 19/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import MapKit

@objc protocol ADSBMapViewListener {
    
   @objc optional func mapView(_ mapView: ADSBMapView, rotationDidChange rotation: Double)
    // message is sent when map rotation is changed
    
}

class ADSBMapView: MKMapView {
    
    private var mapContainerView : UIView? // MKScrollContainerView - map container that rotates and scales
    private var zoom : Float = -1 // saved zoom value
    private var rotation : Double = 0 // saved map rotation
    private var changesTimer : Timer? // timer to track map changes; nil when changes are not tracked
    public var listener : ADSBMapViewListener?
    var altitudeStick = CALayer()
    override public init(frame: CGRect) {
        super.init(frame: frame)
        mapContainerView = self.findViewOfType("MKScrollContainerView", inView: self)
        startTrackingChanges()
        drawAltitudeReferenceColorStick()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mapContainerView = self.findViewOfType("MKScrollContainerView", inView: self)
        startTrackingChanges()
    }
    
    //MARK:-
    //MARK: Draw Altitude color stick
    func drawAltitudeReferenceColorStick(){
        altitudeStick.frame = CGRect(x: 10, y: 10, width: 30, height: bounds.height - 10)
        altitudeStick.borderColor = UIColor.red.cgColor
        altitudeStick.borderWidth = 2
        
        
        
        
        layer.addSublayer(altitudeStick)
    }
    
    
    //MARK:-
    //MARK:    GETTING MAP PROPERTIES

    public func getZoom() -> Double {
        // function returns current zoom of the map
        var angleCamera = self.rotation
        if angleCamera > 270 {
            angleCamera = 360 - angleCamera
        } else if angleCamera > 90 {
            angleCamera = fabs(angleCamera - 180)
        }
        let angleRad = Double.pi * angleCamera / 180 // map rotation in radians
        let width = Double(self.frame.size.width)
        let height = Double(self.frame.size.height)
        let heightOffset : Double = 20 // the offset (status bar height) which is taken by MapKit into consideration to calculate visible area height
        // calculating Longitude span corresponding to normal (non-rotated) width
        let spanStraight = width * self.region.span.longitudeDelta / (width * cos(angleRad) + (height - heightOffset) * sin(angleRad))
        return log2(360 * ((width / 128) / spanStraight))
    }
    
    func getRotation() -> Double? {
        // function gets current map rotation based on the transform values of MKScrollContainerView
        if self.mapContainerView != nil {
            var rotation = fabs(180 * asin(Double(self.mapContainerView!.transform.b)) / Double.pi)
            if self.mapContainerView!.transform.b <= 0 {
                if self.mapContainerView!.transform.a >= 0 {
                    // do nothing
                } else {
                    rotation = 180 - rotation
                }
            } else {
                if self.mapContainerView!.transform.a <= 0 {
                    rotation = rotation + 180
                } else {
                    rotation = 360 - rotation
                }
            }
            return rotation
        } else {
            return nil
        }
    }
    
    

    //MARK:   HANDLING MAP CHANGES
    
    @objc private func trackChanges() {
        // function detects map changes and processes it
        if let rotation = self.getRotation() {
            if rotation != self.rotation {
                self.rotation = rotation
                self.listener?.mapView?(self, rotationDidChange: rotation)
            }
        }
    }
    
    
    func startTrackingChanges() {
        // function starts tracking map changes
        if self.changesTimer == nil {
            self.changesTimer = Timer(timeInterval: 0.1,
                                      target: self,
                                      selector: #selector(ADSBMapView.trackChanges),
                                      userInfo: nil,
                                      repeats: true)
            RunLoop.current.add(self.changesTimer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    
    func stopTrackingChanges() {
        // function stops tracking map changes
        if self.changesTimer != nil {
            self.changesTimer!.invalidate()
            self.changesTimer = nil
        }
    }
    

    
    //MARK:    HELPER FUNCTIONS
    
    func findViewOfType(_ type: String, inView view: UIView) -> UIView? {
        // function scans subviews recursively and returns reference to the found one of a type
        if view.subviews.count > 0 {
            for subview in view.subviews {
                if type(of: subview).description() == type {
                    return subview
                }
                if let inSubviews = self.findViewOfType(type, inView: subview) {
                    return inSubviews
                }
            }
            return nil
        } else {
            return nil
        }
    }

    
}

