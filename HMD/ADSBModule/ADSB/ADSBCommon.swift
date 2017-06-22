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
    static let scanRangeBase: Float = 55  // KM
    static let minimumScanRange: Float = 10
    static let scanFrequencyBase: Int = 7
    static let minimumAircraftsTracking: Int = 5
    static let maximumAircraftsTracking: Int = 80
    
}


public enum ADSBAircraftType: String {
    case none = "ADSBUnknownAirplane_35m"
    //Conditions: Engines = 2; EngType = .Turbo; WTC = .Light; Species = (not tower or car); EngMount =
    case jetTwoEngLight = "ADSBJetTwoEngLight_20.9m"
    //⭕️(20.90m)
    case jetTwoEngMediumB = "ADSBJetTwoEngMedium_31.2m" //⭕️(31.20m)

    case jetTwoEngMediumC = "ADSBJetTwoEngMedium_36.4m" //⭕️(36.40m)
    case jetTwoEngHeavy = "ADSBJetTwoEngHeavy_73.78m" //⭕️(73.78m)
    
    case jetFourEngMedium = "ADSBJetFourEngMedium_59.4m"//⭕️(59.40m)
    case jetFourEngHeavy =  "ADSBJetFourEngHeavy_72.72m"//⭕️(72.72m)
    
    
    case pistonOneEngLight = "ADSBPistonOneEngLight_9.75m"  //⭕️(09.75m)
    
    case pistonTwoEngLight = "ADSBPistonTwoEngLight_15.81m"   //⭕️(15.81m)
    case turboTwoEngMedium = "ADSBTurboTwoEngMedium_27m"  //⭕️(32.80m)
    case turboTwoEngHeavy  = "ADSBTurboTwoEngHeavy_32.80m" //(15.81m)
    
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
