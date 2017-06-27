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
    public var isFullScreen: Bool = true
    let altitudeStickLayer = CALayer()
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    override var bounds: CGRect {
        didSet{
            print("\(bounds)")
            drawAltitudeReferenceColorStick()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        mapContainerView = self.findViewOfType("MKScrollContainerView", inView: self)
        startTrackingChanges()
    }
    
    override func didMoveToSuperview() {
        print("is Full Scree \(isFullScreen)")
        print("screen size \(superview?.frame)")
    }
    
    
    //MARK:-
    //MARK: Draw Altitude color stick
    func drawAltitudeReferenceColorStick(){
//        altitudeStickLayer.borderWidth = 1
//        altitudeStickLayer.borderColor = UIColor.blue.cgColor
        altitudeStickLayer.removeFromSuperlayer()
        altitudeStickLayer.sublayers = nil
        if bounds.height > 100 {
            altitudeStickLayer.frame = CGRect(x: 18, y: 49, width: 50, height: bounds.height - 73)
            let colorStickLayer = CAGradientLayer()
            colorStickLayer.frame = CGRect(x: 0, y: 5, width: 8, height: altitudeStickLayer.bounds.height - 10)
            colorStickLayer.colors = [UIColor(red: 1, green: 0, blue: 1, alpha: 0.6).cgColor as AnyObject,
                                      UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 0, green: 1, blue: 1, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 1, green: 1, blue: 0, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor as AnyObject]
            colorStickLayer.locations = [0, 0.21, 0.67, 0.79, 0.91, 1] as [NSNumber]?
            //        colorStickLayer.locations = [0, 0.21, 0.67, 0.79, 1] as [NSNumber]?
            colorStickLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            colorStickLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            altitudeStickLayer.addSublayer(colorStickLayer)
            
            drawAltitudeScale(by: [0, 400, 2000, 5000, 10000, 20000, 40000], on: colorStickLayer)
        } else {
            
            altitudeStickLayer.frame = CGRect(x: 2, y: 2, width: 40, height: bounds.height - 2)
            let colorStickLayer = CAGradientLayer()
            colorStickLayer.frame = CGRect(x: 0, y: 5, width: 8, height: altitudeStickLayer.bounds.height - 10)
            colorStickLayer.colors = [UIColor(red: 1, green: 0, blue: 1, alpha: 0.6).cgColor as AnyObject,
                                      UIColor(red: 0, green: 0, blue: 1, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 0, green: 1, blue: 1, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 0, green: 1, blue: 0, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 1, green: 1, blue: 0, alpha: 1).cgColor as AnyObject,
                                      UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor as AnyObject]
            colorStickLayer.locations = [0, 0.21, 0.67, 0.79, 0.91, 1] as [NSNumber]?
            //        colorStickLayer.locations = [0, 0.21, 0.67, 0.79, 1] as [NSNumber]?
            colorStickLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            colorStickLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            altitudeStickLayer.addSublayer(colorStickLayer)
            drawAltitudeScale(by: [ 400, 10000, 40000], on: colorStickLayer)
            
//            altitudeStickLayer.frame = CGRect(x: 2, y: 2, width: , height: <#T##CGFloat#>)
        }
        layer.addSublayer(altitudeStickLayer)
    }
    
    func drawAltitudeScale(by altitudeArray: [CGFloat], on layer: CALayer){
        for altitude in altitudeArray {
            let scaleY = getScaleHeight(by: altitude, on: layer)
            layer.drawLine(fromPoint: CGPoint(x: 0, y: scaleY),
                           toPoint: CGPoint(x: 10, y: scaleY ),
                           width: 1)
            let altitudeLabel: CATextLayer = CATextLayer()
            altitudeLabel.frame = CGRect(x: 8, y: scaleY - 7, width: 40, height: 15)
            var altutudeNumber: Int
            if altitude > 1000 {
                altutudeNumber = Int(altitude / 1000)
                altitudeLabel.string = String("\(altutudeNumber)k ")
            } else {
                altitudeLabel.string = String("\(Int(altitude)) ")
            }
            altitudeLabel.fontSize = 12
            altitudeLabel.contentsScale = UIScreen.main.scale
//            altitudeLabel.borderColor = UIColor.red.cgColor
//            altitudeLabel.borderWidth = 1
            altitudeLabel.alignmentMode = kCAAlignmentCenter
            altitudeLabel.foregroundColor = UIColor.blue.cgColor
            layer.addSublayer(altitudeLabel)
        }
    }
    
    func getScaleHeight(by altitude: CGFloat, on layer: CALayer) -> CGFloat{
        let maxiumAltitude: CGFloat = ADSBConfig.maxAltitudeHeight
        let scaleY = CGFloat(1 - sqrt(100 * altitude / maxiumAltitude) / 10) * layer.frame.height
        return scaleY
    }
    
//    
//    func getColorfromPixel(_ pixelPoint:CGPoint, from layer: CALayer) -> UIColor{
//        var pixel: [CUnsignedChar] = [0, 0, 0, 0]
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        
//        let context = CGContext(data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
//        
//        context!.translateBy(x: -pixelPoint.x, y: -pixelPoint.y)
//        
//        layer.render(in: context!)
//        
//        let red: CGFloat   = CGFloat(pixel[0]) / 255.0
//        let green: CGFloat = CGFloat(pixel[1]) / 255.0
//        let blue: CGFloat  = CGFloat(pixel[2]) / 255.0
//        let alpha: CGFloat = CGFloat(pixel[3]) / 255.0
//        
//        let color = UIColor(red:red, green: green, blue:blue, alpha:alpha)
//        
//        return color
//    }
    
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

