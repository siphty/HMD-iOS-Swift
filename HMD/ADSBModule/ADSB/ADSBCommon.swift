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


public enum ADSBAircraftType: String {
    case none = "ADSBUnknownAirplane_35m"
    
    case jetTwoEngLight = "ADSBJetTwoEngLight_20.9m"
    //⭕️(20.90m)    Engines = 2; EngType = .Turbo; WTC = .Light; Species = (not tower or car); EngMount =
    case jetTwoEngMedium = "ADSBJetTwoEngMedium_31.2m" //⭕️(31.20m)    Engines = 2; EngType = .Turbo; WTC = .Medium; Species = (not tower or car); EngMount =

    case turboTwoEngMedium = "ADSBTurboTwoEngMedium_36.4m" //⭕️(36.40m)    Engines = 2; EngType = .Turbo; WTC = .Medium; Species = (not tower or car); EngMount =
    case turboTwoEngHeavy = "ADSBTurboTwoEngHeavy_73.78m" //⭕️(73.78m)    Engines = 2; EngType = .Turbo; WTC = .Heavy; Species = (not tower or car); EngMount =
    
    case turboFourEngMedium = "ADSBTurboFourEngMedium_59.4m"//⭕️(59.40m)    Engines = 4; EngType = .Turbo; WTC = .Light; Species = (not tower or car); EngMount =
    case turboFourEngHeavy =  "ADSBTurboFourEngHeavy_72.72m"//⭕️(72.72m)    Engines = 4; EngType = .Turbo; WTC = .Heavy; Species = (not tower or car); EngMount =
    
    
    case propOneEngLight = "ADSBPistonOneEngLight_7.34m"  //⭕️(09.75m)    Engines = 1; EngType = .Piston; WTC = .Light; Species = (not tower or car); EngMount =
    
    case propTwoEngLight = "ADSBPistonTwoEngLight_15.81m"   //⭕️(15.81m)    Engines = 2; EngType = .Piston; WTC = .Light; Species = (not tower or car); EngMount =
    case propTwoEngMedium = "ADSBPistonTwoEngMedium_27m"  //⭕️(32.80m)    Engines = 2; EngType = .Piston; WTC = .Medum; Species = (not tower or car); EngMount =
    case propTwoEngHeavy  = "ADSBPistonTwoEngHeavy_32.80m" //(15.81m)    Engines = 2; EngType = .Piston; WTC = .Heavy; Species = (not tower or car); EngMount =
    
//    case propFourEngMedium =
//    case propFourEngHeavy
    
    
    case heliLight = "ADSBHeliLight_9.8m"      //⭕️(09.80m)  WTC = .Light; Species = Helicopter;
    case heliMedium = "ADSBHeliMedium_21m"        //⭕️(21.00m)  WTC = .Medum; Species = Helicopter;
    case heliHeavy = "ADSBHeliHeavy_40m"         //⭕️(40.00m)  WTC = .Heavy; Species = Helicopter;
    
    case militaryJet = "ADSBMilitary_18.92m"       //⭕️(18.92m) isMilitary = true;
    
    case uavMultirotor = "ADSBDrone"     //⭕️
    case groundVehicle = "ADSBGroundVehicle"
    case tower = "ADSBTower"
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


public enum ADSBEngineType: Int {
    case None = 0
    case Piston
    case Turbo
    case Jet
    case Electric
}

public enum ADSBWakeTurbulenceCategory: Int {
    case None = 0
    case Light
    case Medium
    case Heavy
}
