//
//  HMDHeadingScaleLayerRenderer.swift
//  Stereoscopic
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDHeadingScaleLayerRenderer: CALayer {
    var didSetup = false
    var shortScalePixels: Int = 10
    var longScalePixels: Int = 16
    var pixelPerUnit: Double = 10.48
    var unitPerShortScale: Int = 1
    var unitPerLongScale: Int = 10
    var unitPerLabel: Int = 10
    var labelSpaceHight: Int = 14
    var unitPerCardinal: Int = 90
    var hasUnderline: Bool = true
    var hasTopline: Bool = true
    var isFacingNorth: Bool = true
    enum Cardinal: Int {
        case north = 0
        case east
        case sourth
        case west
    }
    
    public override func display() {
        print("needsLayout ARRulerScaleLayerRenderer")
//        setup()

        super.display()
    }

    
    
    public override init(){
        super.init()
        print("init HMDHeadingRenderer")
//        if !didSetup {
//            didSetup = true
//            setup()
//        }
        
    }
    
    public func setupWithUnit(_: String, range: ClosedRange<Int>, pixelsToUnit pixels: Int){
        print("init ARRulerScaleLayerRenderer")
//        if !didSetup {
//            didSetup = true
            setup()
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        if !didSetup {
//            didSetup = true
//            setup()
//        }
    }
    
    
    override func layoutSublayers() {
        super.layoutSublayers()


    }
    
    func setup () {
        print("setup HMDHeadingScaleLayerRenderer")
        frame = CGRect(x: 0, y: 0, width: Int(pixelPerUnit * 360.0), height: Int(frame.height))
        sublayers?.forEach { $0.removeFromSuperlayer() }
        for i in 0 ... 360 {
            // Draw scale lines (both long and short lines)
            if (i % unitPerLongScale) == 0 {
                let n = i / unitPerLongScale
                let scalePositionX = Int(Double(n * unitPerLongScale) * pixelPerUnit)
                let startPoint = CGPoint(x: scalePositionX, y: labelSpaceHight + 1)
                let endPoint = CGPoint(x: scalePositionX, y: labelSpaceHight + 1 + longScalePixels)
                drawLine(fromPoint: startPoint, toPoint: endPoint, withLength: longScalePixels, width: 1)
                
            } else if (i % unitPerShortScale) == 0 {
                
                let scalePositionX = Int(Double(i * unitPerShortScale) * pixelPerUnit)
                let startPoint = CGPoint(x: scalePositionX, y: labelSpaceHight + 4)
                let endPoint = CGPoint(x: scalePositionX, y: labelSpaceHight + 4 + shortScalePixels)
                drawLine(fromPoint: startPoint, toPoint: endPoint, withLength: shortScalePixels, width: 1)
            }
            
            // Draw number label and cardinal label
            if (i % unitPerCardinal) == 0 {
                let n = i / unitPerCardinal
                let positionX = Int(Double(n * unitPerCardinal) * pixelPerUnit)
                let label = CATextLayer()
                label.font = "Tahoma" as CFTypeRef
                label.fontSize = 12
                label.contentsScale = UIScreen.main.scale
                label.frame = CGRect(x: positionX - 10, y: 1, width: 20, height: labelSpaceHight)
                switch n % 4{
                case 0:
                    if isFacingNorth == true {
                        label.string = "S"
                    } else {
                        label.string = "N"
                    }
                case 1:
                    if isFacingNorth == true {
                        label.string = "W"
                    } else {
                        label.string = "E"
                    }
                case 2:
                    if isFacingNorth == true {
                        label.string = "N"
                    } else {
                        label.string = "S"
                    }
                case 3:
                    if isFacingNorth == true {
                        label.string = "E"
                    } else {
                        label.string = "W"
                    }
                default:
                    label.string = ""
                }
                label.alignmentMode = kCAAlignmentCenter
                label.foregroundColor = UIColor.green.cgColor
                addSublayer(label)
                
            } else if (i % unitPerLabel) == 0 {
                
                let n = i / unitPerLongScale
                let positionX = Int(Double(n * unitPerLongScale) * pixelPerUnit)
                //                let positionY = labelSpaceHight / 2
                let label = CATextLayer()
                label.font = "Tahoma" as CFTypeRef
                label.fontSize = 12
                label.contentsScale = UIScreen.main.scale
                label.frame = CGRect(x: positionX - 10, y: 1, width: 20, height: labelSpaceHight)
                if isFacingNorth == true {
                    var scaleNumber: Int
                    if i < 180 {
                        scaleNumber = 180 + i
                    } else {
                        scaleNumber = i - 180
                    }
                    label.string = String(scaleNumber)
                } else {
                    label.string = String(i)
                }
                label.alignmentMode = kCAAlignmentCenter
                label.foregroundColor = UIColor.green.cgColor
                addSublayer(label)
                
            }
        }
//        masksToBounds = true

    }
    
    func drawLine(fromPoint start: CGPoint, toPoint end:CGPoint, withLength length: Int, width: Int){
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = CGFloat(width)
        if isFacingNorth {
            line.strokeColor = UIColor.green.cgColor
        } else {
            line.strokeColor = UIColor.yellow.cgColor
        }
        addSublayer(line)
    }
    

}
