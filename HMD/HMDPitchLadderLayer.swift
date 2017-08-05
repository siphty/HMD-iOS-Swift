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
    var labelFontSize: CGFloat = 12.0
    var labelHeight: CGFloat = 14.0
    var labelWidth: CGFloat = 20.0
    
    
    func setup() {
        let ladder = CALayer()
        ladder.frame = bounds
        let ladderFrame = ladder.frame
        for var degree in -100 ... +100 {
            offsetDegree = degree + 100
            degree = degree * -1
            if offsetDegree % degreesPerScale == 0 {
                let positionY = CGFloat(offsetDegree) * pixelsPerDegree
                
                if degree > 0 {
                    
                    let leftLabel = CATextLayer()
                    leftLabel.font = "Tahoma" as CFTypeRef
                    leftLabel.fontSize = labelFontSize
                    leftLabel.contentsScale = UIScreen.main.scale
                    leftLabel.frame = CGRect(x: ladderFrame.width.half() - gapWidth.half() - scaleWidth,
                                             y: positionY ,
                                             width: labelWidth,
                                             height: labelHeight - 1)
                    leftLabel.string = String(Int(floor(Double(degree))))
                    leftLabel.alignmentMode = kCAAlignmentCenter
                    leftLabel.foregroundColor = HMDColor.redScale
                    leftLabel.shadowColor = LayerShadow.Color
                    leftLabel.shadowOffset = LayerShadow.Offset
                    leftLabel.shadowRadius = LayerShadow.Radius
                    leftLabel.shadowOpacity = LayerShadow.Opacity
                    addSublayer(leftLabel)
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half() - scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half() + scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY + bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY + bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    let rightLabel = CATextLayer()
                    rightLabel.font = "Tahoma" as CFTypeRef
                    rightLabel.fontSize = labelFontSize
                    rightLabel.contentsScale = UIScreen.main.scale
                    rightLabel.frame = CGRect(x: ladderFrame.width.half() + gapWidth.half() + scaleWidth - labelWidth,
                                              y: positionY,
                                              width: labelWidth,
                                              height: labelHeight - 1)
                    rightLabel.string = String(Int(floor(Double(degree))))
                    rightLabel.alignmentMode = kCAAlignmentCenter
                    rightLabel.foregroundColor = HMDColor.redScale
                    rightLabel.shadowColor = LayerShadow.Color
                    rightLabel.shadowOffset = LayerShadow.Offset
                    rightLabel.shadowRadius = LayerShadow.Radius
                    rightLabel.shadowOpacity = LayerShadow.Opacity
                    addSublayer(rightLabel)
                    
                }else if degree < 0 {
                    let leftLabel = CATextLayer()
                    leftLabel.font = "Tahoma" as CFTypeRef
                    leftLabel.fontSize = labelFontSize
                    leftLabel.contentsScale = UIScreen.main.scale
                    leftLabel.frame = CGRect(x: ladderFrame.width.half() - gapWidth.half() - scaleWidth,
                                             y: positionY - labelHeight,
                                             width: labelWidth,
                                             height: labelHeight)
                    leftLabel.string = String(Int(floor(Double(degree))))
                    leftLabel.alignmentMode = kCAAlignmentCenter
                    leftLabel.foregroundColor = HMDColor.redScale
                    leftLabel.shadowColor = LayerShadow.Color
                    leftLabel.shadowOffset = LayerShadow.Offset
                    leftLabel.shadowRadius = LayerShadow.Radius
                    leftLabel.shadowOpacity = LayerShadow.Opacity
                    addSublayer(leftLabel)
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half() - scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: true)
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half() + scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: true)
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY - bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY - bracketHeight)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    let rightLabel = CATextLayer()
                    rightLabel.font = "Tahoma" as CFTypeRef
                    rightLabel.fontSize = labelFontSize
                    rightLabel.contentsScale = UIScreen.main.scale
                    rightLabel.frame = CGRect(x: ladderFrame.width.half() + gapWidth.half() + scaleWidth - labelWidth,
                                              y: positionY - labelHeight,
                                              width: labelWidth,
                                              height: labelHeight)
                    rightLabel.string = String(Int(floor(Double(degree))))
                    rightLabel.alignmentMode = kCAAlignmentCenter
                    rightLabel.foregroundColor = HMDColor.redScale
                    rightLabel.shadowColor = LayerShadow.Color
                    rightLabel.shadowOffset = LayerShadow.Offset
                    rightLabel.shadowRadius = LayerShadow.Radius
                    rightLabel.shadowOpacity = LayerShadow.Opacity
                    addSublayer(rightLabel)
                    
                } else {
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half() - scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() - gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                    
                    
                    sPoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half() + scaleWidth,
                                     y: positionY)
                    ePoint = CGPoint(x: ladderFrame.width.half() + gapWidth.half(),
                                     y: positionY)
                    ladder.drawLine(fromPoint: sPoint, toPoint: ePoint, width: 1, isDash: false)
                }
            }
        }
        addSublayer(ladder)
    }
}
