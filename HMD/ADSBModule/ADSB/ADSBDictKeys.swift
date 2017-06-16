//
//  ADSBDictKeys.swift
//  HMD
//
//  Created by Yi JIANG on 16/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

struct ADSBXResponseKeys {
    static let ListId:          String = "lastDv"   //Identifies the version of the aircraft list.
    static let TotalAircraft:   String = "totalAc"  //The total number of aircraft tracked by the list.
    static let TotalSource:     String = "src"      //The source that the feed is working from.
    static let HasSilhouettes:  String = "showSil"  //Depreciated
    static let HasOperator:     String = "showFlg"  //Depreciated
    static let HasPpictures:    String = "showPic"  //Depreciated
    static let PixelWidth:      String = "flgW"     //Depreciated
    static let PixelHeight:     String = "flgH"     //Depreciated
    static let ShortTrailSec:   String = "shtTrlSec"//The number of seconds of positions that short trails contain.
    static let TimeStamp:       String = "stm"      //The server time at UTC in JavaScript ticks.
    static let AircraftList:    String = "acList"   //The aircraft list.
    static let FeedList:        String = "feeds"    //A list of every feed configured on the server.
    static let FeedId:          String = "srcFeed"  //The ID of the feed that was used to generate the list.
    static let HasConfigChanged:String = "configChanged"//True if the server configuration has been changed since the last fetch.
    
}

struct ADSBFlightKeys {
    static let AircraftId:      String = "Id" //The unique identifier of the aircraft.
    static let TrackedSec:      String = "TSecs" //The number of seconds that the aircraft has been tracked for.
    static let ReceiverId:      String = "Rcvr" //he ID of the feed that last supplied information about the aircraft.
    static let IcaoId:          String = "Icao" //The ICAO of the aircraft.
    static let IsNotIcao:       String = "Bad" //True if the ICAO is known to be invalid. This information comes from the local BaseStation.sqb database.
    static let Registration:    String = "Reg" //The registration.
    static let PresAltitude:    String = "Alt" //The altitude in feet at standard pressure.
    static let GndPresAltitude: String = "GAlt" //The altitude adjusted for local air pressure, should be roughly the height above mean sea level.
    static let PresInHg:        String = "InHg" //The air pressure in inches of mercury that was used to calculate the AMSL altitude from the standard pressure altitude.
    static let AltitudeType:    String = "AltT" //The type of altitude transmitted by the aircraft: 0 = standard pressure altitude, 1 = indicated altitude (above mean sea level). Default to standard pressure altitude until told otherwise.
    static let TargetAltitude:  String = "TAlt" //The target altitude, in feet, set on the autopilot / FMS etc.
    static let Callsign:        String = "Call" //The callsign.
    static let IsCallsignUnsure:String = "CallSus" //True if the callsign may not be correct.
    static let Latitude:        String = "Lat" //The aircraft's latitude over the ground.
    static let Longitude:       String = "Long" //The aircraft's longitude over the ground.
    static let LastPosTime:     String = "PosTime" //The time (at UTC in JavaScript ticks) that the position was last reported by the aircraft.
    static let IsGettedByMLAT:  String = "Mlat" //True if the latitude and longitude appear to have been calculated by an MLAT server and were not transmitted by the aircraft.
    static let IsPositionOld:   String = "PosStale" //True if the last position update is older than the display timeout value - usually only seen on MLAT aircraft in merged feeds.
    static let IsTISBSource:    String = "IsTisb" //True if the last message received for the aircraft was from a TIS-B source.
    static let GroundSpeed:     String = "Spd" //The ground speed in Knots.
    static let SpeedType:       String = "SpdTyp" //The type of speed that Spd represents. Only used with raw feeds. 0/missing = ground speed, 1 = ground speed reversing, 2 = indicated air speed, 3 = true air speed.
    static let VertiSpeed:      String = "Vsi" //Vertical speed in Feet per Minute.
    static let VertiSpeedType:  String = "VsiT" //0 = vertical speed is barometric, 1 = vertical speed is geometric. Default to barometric until told otherwise.
    static let TrackAngle:      String = "Trak" //Aircraft's track angle across the ground clockwise from 0° north.
    static let TrackIsHeading:  String = "TrkH" //True if Trak is the aircraft's heading, false if it's the ground track. Default to ground track until told otherwise.
    static let TargetHeading:   String = "TTrk" //The track or heading currently set on the aircraft's autopilot or FMS.
    static let AcICAOType:      String = "Type" //The aircraft model's ICAO type code.
    static let AircraftModel:   String = "Mdl" //A description of the aircraft's model. Usually also includes the manufacturer's name.
    static let Manufacture:     String = "Man" //The manufacturer's name.
    static let AircraftSN:      String = "CNum" //The aircraft's construction or serial number.
    static let Departure:       String = "From" //The code and name of the departure airport.
    static let Destination:     String = "To" //The code and name of the arrival airport.
    static let RouteStops:      String = "Stops" //An array of strings, each being a stopover on the route.
    static let Operator:        String = "Op" //The name of the aircraft's operator.
    static let OperatorICAO:    String = "OpCode" //The operator's ICAO code.
    static let SquawkId:        String = "Sqk" //The squawk as a decimal number
    static let IsEmergency:     String = "Help" //True if the aircraft is transmitting an emergency squawk.
    static let ViewDistance:    String = "Dst" //The distance to the aircraft in kilometres.
    static let ViewBearing:     String = "Brng" //The bearing from the browser to the aircraft clockwise from 0° north.
    static let WTC:             String = "WTC" //The wake turbulence category of the aircraft - see enums.js for values.
    static let EngineCount:     String = "Engines" //The number of engines the aircraft has.
    static let EngineType:      String = "EngType" //The type of engine the aircraft uses
    static let EngineMount:     String = "EngMount" //The placement of engines on the aircraft
    static let AircraftSpecies: String = "Species" //The species of the aircraft
    static let IsMilitary:      String = "Mil" //True if the aircraft appears to be operated by the military.
    static let RegCountry:      String = "Cou" //The country that the aircraft is registered to.
    static let HasPicture:      String = "HasPic" //True if the aircraft has a picture associated with it.
    static let PictureWidth:    String = "PicX" //The width of the picture in pixels.
    static let PictureHeight:   String = "PicY" //The height of the picture in pixels.
    static let FlightsCount:    String = "FlightsCount" //The number of Flights records the aircraft has in the database.
    static let MessagesCount:   String = "CMsgs" //The count of messages received for the aircraft.
    static let IsOnGround:      String = "Gnd" //True if the aircraft is on the ground.
    static let AircraftUserTag: String = "Tag" //The user tag found for the aircraft in the BaseStation.sqb local database.
    static let IsInterested:    String = "Interested" //True if the aircraft is flagged as interesting in the BaseStation.sqb local database.
    static let TrailType:       String = "TT" //Trail type - empty for plain trails, 'a' - trails that include altitude, 's' - trails that include speed.
    static let TransponderType: String = "Trt" //Transponder type - 0=Unknown, 1=Mode-S, 2=ADS-B (unknown version), 3=ADS-B 0, 4=ADS-B 1, 5=ADS-B 2.
    static let YearOfManuf:     String = "Year" //The year that the aircraft was manufactured.
    static let SatCom:          String = "Sat" //True if the aircraft has been seen on a SatCom ACARS feed (e.g. a JAERO feed).
    static let ShortTrails:     String = "Cos" //Short trails
    static let FullTrails:      String = "Cot" //Full trails
    static let ResetTrail:      String = "ResetTrail" //True if the entire trail has been sent
    static let HasSignalLevel:  String = "HasSig" //True if the aircraft has a signal level associated with it.
    static let SignalLevel:     String = "Sig" //The signal level for the last message received from the aircraft, as reported by the receiver.
}
