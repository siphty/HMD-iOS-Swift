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
    static let  serviceCeiling: CGFloat = 6000.0
    static let  max: CGFloat = 500.0
    static let  legal: CGFloat = 120.0
    static let  low: CGFloat = 5.0
}

public struct StateColor{
    static let Danger = UIColor.red.cgColor
    static let Alert = UIColor.orange.cgColor
    static let Caution = UIColor.yellow.cgColor
    static let Normal = HMDColor.redScale
}

public struct LayerShadow{
    static let Color = UIColor.black.cgColor
    static let Offset = CGSize(width: 0, height: 0)
    static let Radius = CGFloat(0.0)
    static let Opacity = Float(0.4)
}
