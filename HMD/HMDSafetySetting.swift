//
//  HMDSafetySetting.swift
//  HMD
//
//  Created by Yi JIANG on 7/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import UIKit


//public enum AltitudeState: Int {
//    case ServiceCeiling = 6000
//    case MaxAltitude = 500
//    case LegalAltitude = 120
//    case LowAltitude = 30
//}
public struct  AltitudeState {
    static let  ServiceCeiling = 6000
    static let  MaxAltitude = 500
    static let  LegalAltitude = 120
    static let  LowAltitude = 30
}

public struct StateColor{
    static let Danger = UIColor.red.cgColor
    static let Alert = UIColor.orange.cgColor
    static let Caution = UIColor.yellow.cgColor
    static let Normal = UIColor.green.cgColor
}
