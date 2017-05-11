//
//  HMDPitchLadderLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDPitchLadderLayer: CALayer {

    
    var pixelsPerDegree: CGFloat = 10.48
    var degreesPerScale: Int = 10
    var scaleWidth: CGFloat = 52
    var gapWidth: CGFloat = 50
    var bracketHeight: CGFloat = 10
    var sPoint: CGPoint = CGPoint(x: 0, y: 0)
    var ePoint: CGPoint = CGPoint(x: 0, y: 0)
    var offsetDegree: Int = 0
    
    
    
    func setup() {
        let ladder = CALayer()
        ladder.frame = bounds
        let lFrame = ladder.frame
        for var degree in -100 ... +100 {
            offsetDegree = degree + 100
            degree = degree * -1
            if offsetDegree % degreesPerScale == 0 {
                let positionY = CGFloat(offsetDegree) * pixelsPerDegree
                
                if degree > 0 {
                    
                    sPoint = CGPoint(x: lFrame.width.half() - gapWidth.half() - scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() + gapWidth.half() + scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY + bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY + bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                }else if degree < 0 {
                    
                    sPoint = CGPoint(x: lFrame.width.half() - gapWidth.half() - scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: true)
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() + gapWidth.half() + scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: true)
                    
                    sPoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY - bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY - bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                } else {
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() - gapWidth.half() - scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: lFrame.width.half() + gapWidth.half() + scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: lFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                }
            }
        }
        addSublayer(ladder)
    }
}
