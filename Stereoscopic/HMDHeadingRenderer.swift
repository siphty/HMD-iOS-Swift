//
//  HMDHeadingRenderer.swift
//  Stereoscopic
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreLocation

class HMDHeadingRenderer: CALayer, CLLocationManagerDelegate {
    
    var didSetup = false
    var translation: CGFloat = 0.0
    var locationManager = CLLocationManager()
    var scrollLayer = CAScrollLayer()
    var lastScrollLayerPostion: CGPoint = CGPoint(x: 0, y: 0)
    var lastHeadingDegree: CLLocationDirection = 0.0
    var enableLoop: Bool = true
    var enableVertical: Bool = false
    var headingScaleNorth = HMDHeadingScaleLayerRenderer()
    var headingScaleSouth = HMDHeadingScaleLayerRenderer() // I need change this someway somehow
    var didInitCompass = false
    var headingNumberWidth: CGFloat = 30.0
    let label = CATextLayer()
    
    internal var orientation: CLDeviceOrientation = CLDeviceOrientation.landscapeRight
    {
        didSet
        {
            locationManager.headingOrientation = self.orientation
        }
    }
    
    
    public override init(){
        super.init()
        print("init HMDHeadingRenderer")
        locationManager.requestWhenInUseAuthorization()
        orientation = getCLDeviceOrientation(by: UIDevice.current.orientation)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.headingFilter = 0.2
        locationManager.headingOrientation =  CLDeviceOrientation.landscapeRight
        locationManager.startUpdatingHeading()
        locationManager.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        scrollLayer = CAScrollLayer()
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        if !didSetup {
            didSetup = true
            setup()
        }
        
    }
    
    func getCLDeviceOrientation(by uiDeviceOrientation: UIDeviceOrientation) -> CLDeviceOrientation {
        switch uiDeviceOrientation {
        case .unknown:
            return CLDeviceOrientation.unknown
        case .portrait:
            return CLDeviceOrientation.portrait
        case .portraitUpsideDown:
            return CLDeviceOrientation.portraitUpsideDown
        case .landscapeLeft:
            return CLDeviceOrientation.landscapeLeft
        case .landscapeRight:
            return CLDeviceOrientation.landscapeRight
        case .faceUp:
            return CLDeviceOrientation.faceUp
        case .faceDown:
            return CLDeviceOrientation.faceDown
        }
    }
    
    func setup () {
        print("setup HMDHeadingRenderer")
        let middleLayer = CALayer()
        middleLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        middleLayer.borderWidth = 1
        middleLayer.borderColor = UIColor.blue.cgColor
        scrollLayer = {
            let scrollLayer = CAScrollLayer()
            scrollLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
            scrollLayer.borderColor = UIColor.green.cgColor
            scrollLayer.borderWidth = 1.0
            
            print(frame.debugDescription)
            print(scrollLayer.frame.debugDescription)
            
//            headingScaleNorth = HMDHeadingScaleLayerRenderer()
            headingScaleNorth.isFacingNorth = true
            headingScaleNorth.backgroundColor = UIColor.blue.cgColor
            headingScaleNorth.setup()
            scrollLayer.addSublayer(headingScaleNorth)
            
            headingScaleSouth.isFacingNorth = false
            headingScaleSouth.backgroundColor = UIColor.green.cgColor
            headingScaleSouth.setup()
            scrollLayer.addSublayer(headingScaleSouth)
            
            headingScaleNorth.isHidden = false
            headingScaleSouth.isHidden = true
            scrollLayer.backgroundColor = UIColor.clear.cgColor
            scrollLayer.scrollMode = kCAScrollHorizontally
            return scrollLayer
        }()
        middleLayer.addSublayer(scrollLayer)
        addSublayer(middleLayer)
//        masksToBounds = false
        
        //Draw Heading Number Lable
        let headingNumberFrame = CGRect(x: (frame.width - headingNumberWidth) / 2, y: 0, width: headingNumberWidth, height: 14)
        middleLayer.doMask(withRect: headingNumberFrame, inverse: true)
        label.font = "Tahoma" as CFTypeRef
        label.fontSize = 12
        label.contentsScale = UIScreen.main.scale
        label.frame = headingNumberFrame
        label.borderColor = UIColor.green.cgColor
        label.borderWidth = 1
        label.alignmentMode = kCAAlignmentCenter
        label.foregroundColor = UIColor.green.cgColor
        addSublayer(label)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingDegree = newHeading.trueHeading
        print("Heading : \(headingDegree)")
        if !didInitCompass {
            
            locationManager.requestWhenInUseAuthorization()
            switch headingDegree {
            case 0 ... 90:
                fallthrough
            case 270 ... 360:
                headingScaleNorth.isHidden = false
                headingScaleSouth.isHidden = true
                let headingPointX = ((headingDegree + 180.0).truncatingRemainder(dividingBy: 360.0)) * headingScaleNorth.pixelPerUnit
                CALayer.performWithoutAnimation {
                    scrollLayer.scroll(to: CGPoint(x: headingPointX - Double(frame.width) / 2 ,
                                                   y: 20.0))
                }
            case 90 ... 270:
                headingScaleNorth.isHidden = true
                headingScaleSouth.isHidden = false
                let headingPointX = headingDegree * headingScaleSouth.pixelPerUnit
                CALayer.performWithoutAnimation {
                    scrollLayer.scroll(to: CGPoint(x: headingPointX - Double(frame.width) / 2 ,
                                                   y: 20.0))
                }
            default:
                print("Something is wrong")
            }
            didInitCompass = true
        } else {
            switch headingDegree {
            case 0 ... 2 :
                fallthrough
            case 358 ... 360:
                label.string = "N"
            case 88 ... 92:
                label.string = "E"
            case 178 ... 182:
                label.string = "S"
            case 268 ... 272:
                label.string = "W"
            default:
                label.string = String(Int(floor(newHeading.trueHeading)))
            }
            
//            var headingPointX =  headingDegree * headingScaleSouth.pixelPerUnit
            var headingPointX = 0.0
            if headingScaleSouth.isHidden {
                if 150.0 ... 210.0 ~= headingDegree  {
                    headingPointX = headingDegree * headingScaleSouth.pixelPerUnit
                    headingScaleNorth.isHidden = true
                    headingScaleSouth.isHidden = false
                } else {
                    headingPointX = ((headingDegree + 180.0).truncatingRemainder(dividingBy: 360.0)) * headingScaleNorth.pixelPerUnit
                }
            } else {
                if 0.0 ... 30.0 ~= headingDegree || 330.0 ... 360.0 ~= headingDegree {
                    headingPointX = ((headingDegree + 180.0).truncatingRemainder(dividingBy: 360.0)) * headingScaleNorth.pixelPerUnit
                    headingScaleNorth.isHidden = false
                    headingScaleSouth.isHidden = true
                } else {
                    headingPointX = headingDegree * headingScaleSouth.pixelPerUnit
                }
            }
//            CALayer.performWithoutAnimation {
                scrollLayer.scroll(to: CGPoint(x: headingPointX - Double(frame.width) / 2,
                                               y: 20.0))
//            }
            
        }
     }
    
    
}


extension CALayer {
    
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void){
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
    
    func doMask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        mask = maskLayer
    }
    
    func doMask(withPath path: UIBezierPath, inverse: Bool = false) {
        let maskLayer = CAShapeLayer()
        
        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = kCAFillRuleEvenOdd
        }
        
        maskLayer.path = path.cgPath
        
        mask = maskLayer
    }
}

