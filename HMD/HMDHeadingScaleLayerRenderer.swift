//
//  HMDHeadingScaleLayerRenderer.swift
//  HMD
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDHeadingScaleLayerRenderer: CALayer {
    var didSetup = false
    var shortScalePixels: CGFloat = 10.0
    var longScalePixels: CGFloat = 16.0
    var pixelPerUnit: CGFloat = 10.48
    var unitPerShortScale: Int = 1
    var unitPerLongScale: Int = 10
    var unitPerLabel: Int = 10
    var labelHeight: CGFloat = 14.0
    var unitPerCardinal: Int = 90
    var hasUnderline: Bool = true
    var hasTopline: Bool = true
    var isFacingNorth: Bool = true
    let scaleColor = UIColor.init(red: 35.0 / 255.0, green: 255.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor
    enum Cardinal: Int {
        case north = 0
        case east
        case sourth
        case west
    }
    
    public override init(){
        super.init()
        print("init HMDHeadingRenderer")
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func layoutSublayers() {
        super.layoutSublayers()


    }
    
    func setup () {
        print("setup HMDHeadingScaleLayerRenderer")
        frame = CGRect(x: 0.0, y: 0.0, width: pixelPerUnit * 360.0, height: frame.height)
        sublayers?.forEach { $0.removeFromSuperlayer() }
        let extraHeight = (frame.height - (labelHeight + 1.0 + longScalePixels))
        longScalePixels = longScalePixels + extraHeight
        shortScalePixels = shortScalePixels + extraHeight
        let longShortDif = (longScalePixels - shortScalePixels) / 2
        for i in 0 ... 360 {
            // Draw scale lines (both long and short lines)
            if (i % unitPerLongScale) == 0 {
                let n = i / unitPerLongScale
                let scalePositionX = CGFloat(n * unitPerLongScale) * pixelPerUnit
                let startPoint = CGPoint(x: scalePositionX, y: labelHeight + 1)
                let endPoint = CGPoint(x: scalePositionX, y: labelHeight + 1.0 + longScalePixels)
                drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
                
            } else if (i % unitPerShortScale) == 0 {
                
                let scalePositionX = CGFloat(i * unitPerShortScale) * pixelPerUnit
                let startPoint = CGPoint(x: scalePositionX, y: labelHeight + 1 + longShortDif)
                let endPoint = CGPoint(x: scalePositionX, y: labelHeight + 1 + longShortDif + shortScalePixels)
                drawLine(fromPoint: startPoint, toPoint: endPoint, width: 1)
            }
            
            // Draw degree label and cardinal label
            if (i % unitPerCardinal) == 0 {
                let n = i / unitPerCardinal
                let positionX = CGFloat(n * unitPerCardinal) * pixelPerUnit
                let label = CATextLayer()
                label.font = "Tahoma" as CFTypeRef
                label.fontSize = 12
                label.contentsScale = UIScreen.main.scale
                label.frame = CGRect(x: positionX - 10, y: 1, width: 20, height: labelHeight)
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
                label.foregroundColor = scaleColor
                addSublayer(label)
                
            } else if (i % unitPerLabel) == 0 {
                
                let n = i / unitPerLongScale
                let positionX = CGFloat(n * unitPerLongScale) * pixelPerUnit
                //                let positionY = labelHeight / 2
                let label = CATextLayer()
                label.font = "Tahoma" as CFTypeRef
                label.fontSize = 12
                label.contentsScale = UIScreen.main.scale
                label.frame = CGRect(x: positionX - 10, y: 1, width: 20, height: labelHeight)
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
                label.foregroundColor = scaleColor
                addSublayer(label)
                
            }
        }
//        masksToBounds = true

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
//        if isFacingNorth {
            line.strokeColor = scaleColor
//        } else {
//            line.strokeColor = UIColor.yellow.cgColor
//        }
        addSublayer(line)
    }
    

}
