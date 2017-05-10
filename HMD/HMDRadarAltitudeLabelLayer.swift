//
//  HMDRadarAltitudeLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreText

class HMDRadarAltitudeLabelLayer: CATextLayer {
//    override var string: Any?{
//        didSet{
//            super.string = string
////            let str: String = "123"
//            if let strNumber = Int(string as! String) {
//                switch strNumber {
//                case AltitudeState.ServiceCeiling ... 99999:
//                    foregroundColor = StateColor.Alert
//                case AltitudeState.MaxAltitude ... AltitudeState.ServiceCeiling:
//                    foregroundColor = StateColor.Caution
//                case AltitudeState.LegalAltitude ... AltitudeState.MaxAltitude:
//                    foregroundColor = StateColor.Caution
//                case AltitudeState.LowAltitude ... AltitudeState.LegalAltitude:
//                    foregroundColor = StateColor.Normal
//                case 0 ... AltitudeState.LowAltitude:
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
