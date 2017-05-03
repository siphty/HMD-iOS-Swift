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
    var cursorScrollLayer = CAScrollLayer()
    var lastScrollLayerPostion: CGPoint = CGPoint(x: 0, y: 0)
    var lastHeadingDegree: CLLocationDirection = 0.0
    var enableLoop: Bool = true
    var enableVertical: Bool = false
    var headingScaleNorth = HMDHeadingScaleLayerRenderer()
    var headingScaleSouth = HMDHeadingScaleLayerRenderer() // I need change this someway somehow
    var didInitCompass = false
    var headingNumberWidth: CGFloat = 30.0
    var scrollLock = false
    let concurrentQueue = DispatchQueue(label: "updateHeading", attributes: .concurrent)
    
    let label = CATextLayer()
    let scaleColor = UIColor.init(red: 35.0 / 255.0, green: 210.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor
    
    
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
        
//        scrollLayer.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        middleLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: 31)

        
        //TODO: I might need two scrollLyaers to make heading tape loop.
        scrollLayer = {
            let scrollLayer = CAScrollLayer()
            scrollLayer.frame = middleLayer.frame
            
            headingScaleNorth.isFacingNorth = true
            headingScaleNorth.backgroundColor = UIColor.clear.cgColor
            headingScaleNorth.frame = scrollLayer.frame
            headingScaleNorth.setup()
            scrollLayer.addSublayer(headingScaleNorth)
            
            headingScaleSouth.isFacingNorth = false
            headingScaleSouth.backgroundColor = UIColor.clear.cgColor
            headingScaleSouth.frame = scrollLayer.frame
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
        
        //Draw Heading Number Lable
        let headingNumberFrame = CGRect(x: (frame.width - headingNumberWidth) / 2,
                                        y: 0,
                                        width: headingNumberWidth,
                                        height: 14)
        middleLayer.doMask(withRect: headingNumberFrame, inverse: true)
        label.font = "Tahoma" as CFTypeRef
        label.fontSize = 12
        label.contentsScale = UIScreen.main.scale
        label.frame = headingNumberFrame
        label.borderColor = scaleColor
        label.borderWidth = 1
        label.alignmentMode = kCAAlignmentCenter
        label.foregroundColor = scaleColor
        addSublayer(label)
        
        //Draw current view heading line
        let startPoint = CGPoint(x: frame.width / 2, y: middleLayer.frame.height)
        let endPoint = CGPoint(x: frame.width / 2, y: frame.height)
        drawLine(fromPoint: startPoint, toPoint: endPoint, width: 2)
        
        //Draw aircraft heading
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let headingDegree = CGFloat(newHeading.trueHeading)

        DispatchQueue.main.async(execute: {
            print("Heading : \(headingDegree)")
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
                    self.headingScaleNorth.isHidden = false
                    self.headingScaleSouth.isHidden = true
                    let headingPointX = ((headingDegree + 180.0).truncatingRemainder(dividingBy: 360.0)) * self.headingScaleNorth.pixelPerUnit
                    CALayer.performWithoutAnimation ({self.scrollLayer.scroll(to: CGPoint(x: headingPointX - self.frame.width / 2 ,
                                                                                          y: 20.0))},
                                                     completionHandler: { self.scrollLock = false })
                case 90 ... 270:
                    self.headingScaleNorth.isHidden = true
                    self.headingScaleSouth.isHidden = false
                    let headingPointX = headingDegree * self.headingScaleSouth.pixelPerUnit
                    CALayer.performWithoutAnimation ({self.scrollLayer.scroll(to: CGPoint(x: headingPointX - self.frame.width / 2 ,
                                                                                          y: 20.0))},
                                                     completionHandler: { self.scrollLock = false })
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
                    self.label.string = "N"
                case 88 ... 92:
                    self.label.string = "E"
                case 178 ... 182:
                    self.label.string = "S"
                case 268 ... 272:
                    self.label.string = "W"
                default:
                    self.label.string = String(Int(floor(newHeading.trueHeading)))
                }
                
    //            var headingPointX =  headingDegree * headingScaleSouth.pixelPerUnit
                var headingPointX: CGFloat = 0.0
                if self.headingScaleSouth.isHidden {
                    if 150.0 ... 210.0 ~= headingDegree  {
                        headingPointX = headingDegree * self.headingScaleSouth.pixelPerUnit
                        self.headingScaleNorth.isHidden = true
                        self.headingScaleSouth.isHidden = false
                    } else {
                        headingPointX = ((headingDegree + 180.0).truncatingRemainder(dividingBy: 360.0)) * self.headingScaleNorth.pixelPerUnit
                    }
                } else {
                    if 0.0 ... 30.0 ~= headingDegree || 330.0 ... 360.0 ~= headingDegree {
                        headingPointX = ((headingDegree + 180.0).truncatingRemainder(dividingBy: 360.0)) * self.headingScaleNorth.pixelPerUnit
                        self.headingScaleNorth.isHidden = false
                        self.headingScaleSouth.isHidden = true
                    } else {
                        headingPointX = headingDegree * self.headingScaleSouth.pixelPerUnit
                    }
                }
                CALayer.performWithoutAnimation ({
                print(self.scrollLayer.animationKeys() ?? "")
//                    self.scrollLayer.scroll(to: CGRect(x: (headingPointX - self.frame.width / 2),
//                                                       y: 0,
//                                                       width: self.frame.width,
//                                                       height: 40))
//                    self.scrollLayer.scroll(to: CGPoint(x: headingPointX - self.frame.width / 2,
//                                                        y: 20.0))
                    self.scrollLayer.bounds =  CGRect(x: (headingPointX - self.frame.width / 2) - self,
                                                      y: 0,
                                                      width: headingPointX - self.frame.width / 2,
                                                      height: 40)
                }, completionHandler: {
                    self.scrollLock = false
                })
                
            }
            
//            self.scrollLock = false
        })
     }
    
    func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, width: Int){
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = CGFloat(width)
        line.strokeColor = scaleColor
        addSublayer(line)
    }
}


extension CALayer {
    
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void,
                                       completionHandler handler: @escaping() -> Void){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            handler()
        })
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

