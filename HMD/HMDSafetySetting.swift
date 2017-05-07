//
//  HMDSafetySetting.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import UIKit


//public enum AltitudeState: Range{
//    case ExceedMaxAltitude = 120 ... 999
//    case safetyAltitude = 30 ... 120
//    case CautionLowAltitude = 0 ... 30
//}
public enum AltitudeState: Int {
    case ServiceCeiling = 6000
    case MaxAltitude = 500
    case LegalAltitude = 120
    case LowAltitude = 30
}

public struct stateColor{
    static let Danger = UIColor.red.cgColor
    static let Alert = UIColor.orange.cgColor
    static let Caution = UIColor.yellow.cgColor
    static let Normal = UIColor.green.cgColor
}
