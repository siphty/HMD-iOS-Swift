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
    static let  NewAerodromeListKey = Notification.Name(rawValue:"ADSBExchangeResponseAerodromeList")
}

public struct ADSBConfig{
    static let isGroundAircraftFilterOn = false
    static let scanRangeBase: Float = 35  // KM
    static let minimumScanRange: Float = 10
    static let scanFrequencyBase: Int = 7
    static let minimumAircraftsTracking: Int = 5
    static let maximumAircraftsTracking: Int = 30
    
}


public enum ADSBAircraftType {
    case none
    case jetTwoEngSmall
    case jetTwoEngMid
    case jetTwoEngLarg
    case jetTwoEngHuge
    case jetFourEngSmall
    case jetFourEngMid
    case jetFourEngLarg
    case jetFourEngHuge
    case propOneEngSmall
    case propTwoEngSmall
    case propTwoEngMid
    case propTwoEngLarg
    case propFourEngSmall
    case propFourEngMid
    case propFourEngLarg
    case propFourEngHuge
    case HeliSmall
    case HeliMid
    case HeliLarg
    case HeliHug
    case unpowered
    case militaryJet
    case militaryProp
    case militaryHeli
    case militaryOther
    case uavMultirotor
    case uavHeli
    case uavJet
    case uavProp
}

public enum ADSBSpecies: Int {
    case None = 0
    case LandPlane
    case SeaPlane
    case Amphibian
    case Helicopter
    case Gyrocopter
    case Tiltwing
    case GroundVehicle
    case Tower
}
