//
//  ARRulerCursorLayerRenderer.swift
//  Stereoscopic
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class ARRulerCursorLayerRenderer: CALayer {
    
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

}
