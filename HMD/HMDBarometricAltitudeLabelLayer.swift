//
//  HMDBarometricAltitudeLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDBarometricAltitudeLabelLayer: CATextLayer {
    //TODO: When I implement didSet, it will get fetal crash. Fix it!
    
//    override var foregroundColor: CGColor?{
//        didSet{
//            super.foregroundColor = foregroundColor
//        }
//    }
//    override var string: Any?{
//        didSet{
//            super.string = string
////            self.set
//            super.foregroundColor = StateColor.Danger
//            if let strNumber = Int(string as! String) {
//                switch strNumber {
//                case AltitudeState.ServiceCeiling.rawValue ... 99999:
//                    foregroundColor = StateColor.Danger
//                case AltitudeState.MaxAltitude.rawValue ... AltitudeState.ServiceCeiling.rawValue:
//                    foregroundColor = StateColor.Alert
//                case AltitudeState.LegalAltitude.rawValue ... AltitudeState.MaxAltitude.rawValue:
//                    foregroundColor = StateColor.Caution
//                case AltitudeState.LowAltitude.rawValue ... AltitudeState.LegalAltitude.rawValue:
//                    foregroundColor = StateColor.Normal
//                case 0 ... AltitudeState.LowAltitude.rawValue:
//                    foregroundColor = StateColor.Caution
//                default:
//                    foregroundColor = StateColor.Normal
//                }
//            }
//        }
//    }

    public override init(){
        super.init()
        print("init HMDBarometricAltitudeLabelLayer")
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 
}
