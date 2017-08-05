//
//  HMDLowAltitudeScaleLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDLowAltitudeScaleLayer: CALayer {
    var longScaleSections: Int = 4
    var shortScaleSections: Int = 5
    var shortScalePixels: CGFloat = 0
    var longScalePixels: CGFloat = 0
//    var pixelsPerShortScale: CGFloat = 0
//    var pixelsPerLongScale: CGFloat = 0
    var shortLongScaleRate: CGFloat = 3 / 5
    
    
    public override init(){
        super.init()
        print("init HMDLowAltitudeScaleLayer")
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func setup() {
        let pixelsPerLongScale = frame.height / CGFloat(longScaleSections)
        let pixelsPerShortScale = pixelsPerLongScale / CGFloat(shortScaleSections)
        let scalesCount = longScaleSections * shortScaleSections
        for i in 0 ... scalesCount {
            if i % shortScaleSections == 0 {
                // Draw a long scale every 5 scales
                drawLine(fromPoint: CGPoint(x: 0.0, y: CGFloat(i) * pixelsPerShortScale),
                         toPoint: CGPoint(x: frame.width, y: CGFloat(i)  * pixelsPerShortScale),
                         width: 1)
            } else if i > ((longScaleSections - 1) * shortScaleSections){
                // Rest scales are short scale
                let gapPixels = frame.width * (1 - shortLongScaleRate) / 2
                drawLine(fromPoint: CGPoint(x: gapPixels, y: CGFloat(i) * pixelsPerShortScale),
                         toPoint: CGPoint(x: frame.width - gapPixels , y: CGFloat(i)  * pixelsPerShortScale),
                         width: 1)
                
            }
        }
        shadowColor = LayerShadow.Color
        shadowOffset = LayerShadow.Offset
        shadowRadius = LayerShadow.Radius
        shadowOpacity = LayerShadow.Opacity
    }
    
}
