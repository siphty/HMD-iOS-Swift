//
//  HMDHeadingRenderer.swift
//  Stereoscopic
//
//  Created by Yi JIANG on 21/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDHeadingRenderer: CALayer {
    
    var didSetup = false
    var translation: CGFloat = 0.0
    
    
    public override init(){
        super.init()
        print("init HMDHeadingRenderer")
//        if !self.didSetup {
//            self.didSetup = true
//            self.setup()
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
    }
    
    func setup () {
        print("setup HMDHeadingRenderer")
        
        let headingScaleLayer = ARRulerScaleLayerRenderer()
        //        addSublayer(headingScaleLayer)
        
        
        let scrollLayer: CAScrollLayer = {
            let scrollLayer = CAScrollLayer()
            scrollLayer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
            scrollLayer.borderColor = UIColor.green.cgColor
            scrollLayer.borderWidth = 2.0
//            scrollLayer.bounds = CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height - 10) // 3
            //            scrollLayer.position = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2) // 10
            print(frame.debugDescription)
            print(scrollLayer.frame.debugDescription)
//            
//            if let skyImage = UIImage(named: "sky") {
//                let imageSize = skyImage.size
//                let imageLayer = CALayer()
//                imageLayer.bounds = CGRect(x: (imageSize.width - frame.width) / 2, y: 0.0, width: frame.width, height: frame.height) // 3
//                imageLayer.position = CGPoint(x: imageSize.width/2, y: imageSize.height/2) // 4
//                imageLayer.contents = skyImage.cgImage
//                imageLayer.contentsGravity = kCAGravityResizeAspectFill
//                scrollLayer.addSublayer(imageLayer)
//            }
            
            scrollLayer.addSublayer(headingScaleLayer)
//            scrollLayer.contents = UIImage(named: "sky")?.cgImage
//            scrollLayer.contentsGravity = kCAGravityResizeAspectFill
//            scrollLayer.position = CGPoint(x: 0, y: 0) // 10
//            scrollLayer.scrollMode = kCAScrollHorizontally
            
            scrollLayer.backgroundColor = UIColor.orange.cgColor
//            headingScaleLayer.frame = scrollLayer.frame
            //            scrollLayer.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
//            scrollLayer.addSublayer(headingScaleLayer)
//            scrollLayer.contentsGravity = kCAGravityCenter
            return scrollLayer
        }()
        addSublayer(scrollLayer)
//        headingScaleLayer.addSublayer(CALayer())
//        masksToBounds = true
        //        var displayLink: CADisplayLink = {
        //            let displayLink = CADisplayLink(target: self, selector: #selector(scrollLayerScroll))
        //            displayLink.frameInterval = 10
        //            return displayLink
        //        }()
        //        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        //
        //
        //
        //        func scrollLayerScroll() {
        //            let newPoint = CGPoint(x: translation, y: 0.0)
        //            scrollLayer.scroll(newPoint)
        //            translation += 10.0
        //            if translation > 1600.0 {
        //                stopDisplayLink()
        //            }
        //        }
        //        
        //        func stopDisplayLink() {
        //            displayLink.invalidate()
        //        }
        
    
    }
    
    
}
