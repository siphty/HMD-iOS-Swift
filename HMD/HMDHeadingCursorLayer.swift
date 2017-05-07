//
//  HMDRulerCursorLayer.swift
//  HMD
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDHeadingCursorLayer: CALayer {
    
    var didSetup = false
//    var 
    
    public override init(){
        super.init()
        // Draw a triangle cursor
        
        
        contents = UIImage(named: "scale")?.cgImage
        contentsGravity = kCAGravityResizeAspect
        backgroundColor = UIColor.clear.cgColor
        frame = CGRect(x: 50, y: 50, width: 100, height: 100)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup () {
        print("setup HMDHeadingScaleLayerRenderer")
//        frame = CGRect(x: 0, y: 0, width: Int(pixelPerUnit * 360.0), height: Int(frame.height))
        
    }

}
