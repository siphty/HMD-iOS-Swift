//
//  ADSBAircraft.swift
//  HMD
//
//  Created by Yi JIANG on 11/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
struct ADSBAircraft { // TODO: Rename this struct
    var aircraftId: Int?
    var trackedSec: Int?
    var receiverId: Int?
    var icaoId: String?
    var isNotIcao: Bool?
    var registration: String?
    var presAltitude: Double?
    var gndPresAltitude: Double?
    var PresInHg: Double?
    var altitudeType: Int?
    var targetAltitude: Double?
    var callsign: String?
    var isCallsignUnsure: Bool?
    var latitude: Double?
    var longitude: Double?
    var lastPosTime: Int?
    var isFoundByMLAT: Bool?
    var isPositionOld: Bool?
    var isTISBSource: Bool?
    var groundSpeed: Double?
    var speedType: Int?
    var vertiSpeed: Int?
    var vertiSpeedType: Int?
    var trackHeading: Double?
    var trackIsHeading: Bool?
    var targetHeading: Double?
    var acICAOType: String?
    var aircraftModel: String?
    var manufacture: String?
    var aircraftSN: String?
    var departure: String?
    var destination: String?
    var routeStops: [String]?
    var acOperator: String?
    var acOperatorICAO: String?
    var squawkId: String?
    var isEmergency: Bool?
    var ViewerDistance: Double?
    var ViewerBearing: Double?
    var wTC: Int?
    var engineCount: Int?
    var engineType: Int?
    var engineMount: Int?
    var aircraftSpecies: Int?
    var isMilitary: Bool?
    var regCountry: String?
    var hasPicture: Bool?
    var pictureWidth: Double?
    var pictureHeight: Double?
    var flightsCount: Int?
    var messagesCount: Int?
    var isOnGround: Bool?
    var aircraftUserTag: String?
    var isInterested: Bool?
    var trailType: String?
    var transponderType: Int?
    var yearOfManuf: String?
    var isSatComFeed: Bool?
    var shortTrails: Any?
    var fullTrails: Any?
    var hasResetTrail: Bool?
    var hasSignalLevel: Bool?
    var signalLevel: Double?
    var fSeen: String?
    
    
    /// Transform aircraft list Diction Array to objct
    ///
    /// - Parameter array: aircraft list Diction Array
    /// - Returns: [ADSBAircraft]?
    static func fromDictArray(_ aircraftArray: [[String: Any]]) -> [ADSBAircraft] {
        var models:[ADSBAircraft] = []
        for aircraft in aircraftArray
        {
            models.append(ADSBAircraft(withDictionary: aircraft))
        }
        return models
    }
    
    init(withDictionary acDict: [String: Any]) {
        aircraftId = acDict[AcKeys.AircraftId] as? Int
        trackedSec = acDict[AcKeys.TrackedSec] as? Int
        receiverId = acDict[AcKeys.ReceiverId] as? Int
        icaoId = acDict[AcKeys.IcaoId] as? String
        isNotIcao = acDict[AcKeys.IsNotIcao] as? Bool
        registration = acDict[AcKeys.Registration] as? String
        presAltitude = acDict[AcKeys.PresAltitude] as? Double
        gndPresAltitude = acDict[AcKeys.AircraftId] as? Double
        PresInHg = acDict[AcKeys.PresInHg] as? Double
        altitudeType = acDict[AcKeys.AltitudeType] as? Int
        targetAltitude = acDict[AcKeys.TargetAltitude] as? Double
        callsign = acDict[AcKeys.Callsign] as? String
        isCallsignUnsure = acDict[AcKeys.IsCallsignUnsure] as? Bool
        latitude = acDict[AcKeys.Latitude] as? Double
        longitude = acDict[AcKeys.Longitude] as? Double
        lastPosTime = acDict[AcKeys.LastPosTime] as? Int
        isFoundByMLAT = acDict[AcKeys.IsFoundByMLAT] as? Bool
        isPositionOld = acDict[AcKeys.IsPositionOld] as? Bool
        isTISBSource = acDict[AcKeys.IsTISBSource] as? Bool
        groundSpeed = acDict[AcKeys.GroundSpeed] as? Double
        speedType = acDict[AcKeys.SpeedType] as? Int
        vertiSpeed = acDict[AcKeys.VertiSpeed] as? Int
        vertiSpeedType = acDict[AcKeys.VertiSpeedType] as? Int
        trackHeading = acDict[AcKeys.TrackHeading] as? Double
        trackIsHeading = acDict[AcKeys.TrackIsHeading] as? Bool
        targetHeading = acDict[AcKeys.TargetHeading] as? Double
        acICAOType = acDict[AcKeys.AcICAOType] as? String
        aircraftModel = acDict[AcKeys.AircraftModel] as? String
        manufacture = acDict[AcKeys.Manufacture] as? String
        aircraftSN = acDict[AcKeys.AircraftSN] as? String
        departure = acDict[AcKeys.Departure] as? String
        destination = acDict[AcKeys.Destination] as? String
        routeStops = acDict[AcKeys.RouteStops] as? [String]
        acOperator = acDict[AcKeys.AcOperator] as? String
        acOperatorICAO = acDict[AcKeys.AcOperatorICAO] as? String
        squawkId = acDict[AcKeys.SquawkId] as? String
        isEmergency = acDict[AcKeys.IsEmergency] as? Bool
        ViewerDistance = acDict[AcKeys.ViewerDistance] as? Double
        ViewerBearing = acDict[AcKeys.ViewerBearing] as? Double
        wTC = acDict[AcKeys.WTC] as? Int
        engineCount = acDict[AcKeys.EngineCount] as? Int
        engineType = acDict[AcKeys.EngineType] as? Int
        engineMount = acDict[AcKeys.EngineMount] as? Int
        aircraftSpecies = acDict[AcKeys.AircraftSpecies] as? Int
        isMilitary = acDict[AcKeys.IsMilitary] as? Bool
        regCountry = acDict[AcKeys.RegCountry] as? String
        hasPicture = acDict[AcKeys.HasPicture] as? Bool
        pictureWidth = acDict[AcKeys.PictureWidth] as? Double
        pictureHeight = acDict[AcKeys.PictureHeight] as? Double
        flightsCount = acDict[AcKeys.FlightsCount] as? Int
        messagesCount = acDict[AcKeys.MessagesCount] as? Int
        isOnGround = acDict[AcKeys.IsOnGround] as? Bool
        aircraftUserTag = acDict[AcKeys.AircraftUserTag] as? String
        isInterested = acDict[AcKeys.IsInterested] as? Bool
        trailType = acDict[AcKeys.TrailType] as? String
        transponderType = acDict[AcKeys.TransponderType] as? Int
        yearOfManuf = acDict[AcKeys.YearOfManuf] as? String
        isSatComFeed = acDict[AcKeys.IsSatComFeed] as? Bool
        shortTrails = acDict[AcKeys.ShortTrails] as Any?
        fullTrails = acDict[AcKeys.FullTrails] as Any?
        hasResetTrail = acDict[AcKeys.HasResetTrail] as? Bool
        hasSignalLevel = acDict[AcKeys.HasSignalLevel] as? Bool
        signalLevel = acDict[AcKeys.SignalLevel] as? Double
        fSeen = acDict["fSeen"] as? String
    }
}
