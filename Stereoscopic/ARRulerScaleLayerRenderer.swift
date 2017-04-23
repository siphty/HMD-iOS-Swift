//
//  ARRulerScaleLayerRenderer.swift
//  Stereoscopic
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class ARRulerScaleLayerRenderer: CALayer {
    var didSetup = false
    var shortScalePixels: Int = 5
    var longScalePixels: Int = 7
    
    public override func needsLayout() -> Bool {
        print("needsLayout ARRulerScaleLayerRenderer")
        if !didSetup {
            didSetup = true
            setup()
            
        }
        return true
    }

    
    
    public override init(){
        super.init()
        print("init HMDHeadingRenderer")
        
    }
    
    public func setupWithUnit(_: String, range: ClosedRange<Int>, pixelsToUnit pixels: Int){
        print("init ARRulerScaleLayerRenderer")
        if !didSetup {
            didSetup = true
            setup()
        }
        
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
    
    func setup () {
        print("setup ARRulerScaleLayerRenderer")
        frame = CGRect(x: 0, y: 0, width: 5040, height: 40)
        borderColor = UIColor.red.cgColor
        borderWidth = 2
        
        if let skyImage = UIImage(named: "sky") {
            let imageSize = skyImage.size
            let imageLayer = CALayer()
            imageLayer.bounds = CGRect(x: (imageSize.width - frame.width) / 2, y: 0.0, width: frame.width, height: frame.height) // 3
            position = CGPoint(x: imageSize.width/2, y: imageSize.height/2) // 4
            contents = skyImage.cgImage
            contentsGravity = kCAGravityResizeAspectFill
        }
    }

}
