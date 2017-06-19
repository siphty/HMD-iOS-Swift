//
//  ADSBCommon.swift
//  HMD
//
//  Created by Yi JIANG on 17/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation



//Notification Center Keys
public struct  ADSBNotification {
    static let  NewAircraftListKey = Notification.Name(rawValue:"ADSBExchangeResponseAircraftList")
}

public struct ADSBConfig{
    static let isGroundAircraftFilterOn = false
    static let scanRangeBase: Float = 35  // KM
    static let minimumScanRange: Float = 10
    static let scanFrequencyBase: Int = 7
    static let minimumAircraftsTracking: Int = 5
    static let maximumAircraftsTracking: Int = 30
    
}
