//
//  HMDBarometricAltitudeLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 6/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDBarometricAltitudeLabelLayer: CATextLayer {
    override var string: Any?{
        didSet{
            super.string = string
            if let strNumber = Int(string as! String) {
                switch strNumber {
                case AltitudeState.ServiceCeiling.rawValue ... 99999:
                    foregroundColor = stateColor.Danger
                case AltitudeState.MaxAltitude.rawValue ... AltitudeState.ServiceCeiling.rawValue:
                    foregroundColor = stateColor.Alert
                case AltitudeState.LegalAltitude.rawValue ... AltitudeState.MaxAltitude.rawValue:
                    foregroundColor = stateColor.Caution
                case AltitudeState.LowAltitude.rawValue ... AltitudeState.LegalAltitude.rawValue:
                    foregroundColor = stateColor.Normal
                case 0 ... AltitudeState.LowAltitude.rawValue:
                    foregroundColor = stateColor.Caution
                default:
                    foregroundColor = stateColor.Normal
                }
            }
        }
    }

    public override init(){
        super.init()
        print("init HMDBarometricAltitudeLabelLayer")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
