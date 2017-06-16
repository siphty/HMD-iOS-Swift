//
//  ADSBFlight.swift
//  HMD
//
//  Created by Yi JIANG on 11/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
struct ADSBFlight: CreatableFromJSON { // TODO: Rename this struct
    let alt: Int?
    let altT: Int
    let bad: Bool
    let brng: Double
    let cMsgs: Int
    let cNum: String
    let call: String
    let callSus: Bool
    let cou: String
    let dst: Double
    let engMount: Int
    let engType: Int
    let engines: String
    let fSeen: String
    let flightsCount: Int
    let from: String?
    let gAlt: Int?
    let gnd: Bool
    let hasPic: Bool
    let hasSig: Bool
    let help: Bool
    let icao: String
    let id: Int
    let inHg: Double
    let interested: Bool
    let lat: Double
    let long: Double
    let man: String
    let mdl: String
    let mil: Bool
    let mlat: Bool
    let op: String
    let opIcao: String
    let posTime: Int
    let rcvr: Int
    let reg: String
    let spd: Double?
    let spdTyp: Int
    let species: Int
    let sqk: String
    let tSecs: Int
    let tisb: Bool
    let to: String?
    let trak: Double?
    let trkH: Bool
    let trt: Int
    let type: String
    let vsi: Int?
    let vsiT: Int
    let wTC: Int
    let year: String
    init(alt: Int?, altT: Int, bad: Bool, brng: Double, cMsgs: Int, cNum: String, call: String, callSus: Bool, cou: String, dst: Double, engMount: Int, engType: Int, engines: String, fSeen: String, flightsCount: Int, from: String?, gAlt: Int?, gnd: Bool, hasPic: Bool, hasSig: Bool, help: Bool, icao: String, id: Int, inHg: Double, interested: Bool, lat: Double, long: Double, man: String, mdl: String, mil: Bool, mlat: Bool, op: String, opIcao: String, posTime: Int, rcvr: Int, reg: String, spd: Double?, spdTyp: Int, species: Int, sqk: String, tSecs: Int, tisb: Bool, to: String?, trak: Double?, trkH: Bool, trt: Int, type: String, vsi: Int?, vsiT: Int, wTC: Int, year: String) {
        self.alt = alt
        self.altT = altT
        self.bad = bad
        self.brng = brng
        self.cMsgs = cMsgs
        self.cNum = cNum
        self.call = call
        self.callSus = callSus
        self.cou = cou
        self.dst = dst
        self.engMount = engMount
        self.engType = engType
        self.engines = engines
        self.fSeen = fSeen
        self.flightsCount = flightsCount
        self.from = from
        self.gAlt = gAlt
        self.gnd = gnd
        self.hasPic = hasPic
        self.hasSig = hasSig
        self.help = help
        self.icao = icao
        self.id = id
        self.inHg = inHg
        self.interested = interested
        self.lat = lat
        self.long = long
        self.man = man
        self.mdl = mdl
        self.mil = mil
        self.mlat = mlat
        self.op = op
        self.opIcao = opIcao
        self.posTime = posTime
        self.rcvr = rcvr
        self.reg = reg
        self.spd = spd
        self.spdTyp = spdTyp
        self.species = species
        self.sqk = sqk
        self.tSecs = tSecs
        self.tisb = tisb
        self.to = to
        self.trak = trak
        self.trkH = trkH
        self.trt = trt
        self.type = type
        self.vsi = vsi
        self.vsiT = vsiT
        self.wTC = wTC
        self.year = year
    }
    init?(json: [String: Any]) {
        guard let altT = json["AltT"] as? Int else { return nil }
        guard let bad = json["Bad"] as? Bool else { return nil }
        guard let brng = Double(json: json, key: "Brng") else { return nil }
        guard let cMsgs = json["CMsgs"] as? Int else { return nil }
        guard let cNum = json["CNum"] as? String else { return nil }
        guard let call = json["Call"] as? String else { return nil }
        guard let callSus = json["CallSus"] as? Bool else { return nil }
        guard let cou = json["Cou"] as? String else { return nil }
        guard let dst = Double(json: json, key: "Dst") else { return nil }
        guard let engMount = json["EngMount"] as? Int else { return nil }
        guard let engType = json["EngType"] as? Int else { return nil }
        guard let engines = json["Engines"] as? String else { return nil }
        guard let fSeen = json["FSeen"] as? String else { return nil }
        guard let flightsCount = json["FlightsCount"] as? Int else { return nil }
        guard let gnd = json["Gnd"] as? Bool else { return nil }
        guard let hasPic = json["HasPic"] as? Bool else { return nil }
        guard let hasSig = json["HasSig"] as? Bool else { return nil }
        guard let help = json["Help"] as? Bool else { return nil }
        guard let icao = json["Icao"] as? String else { return nil }
        guard let id = json["Id"] as? Int else { return nil }
        guard let inHg = Double(json: json, key: "InHg") else { return nil }
        guard let interested = json["Interested"] as? Bool else { return nil }
        guard let lat = Double(json: json, key: "Lat") else { return nil }
        guard let long = Double(json: json, key: "Long") else { return nil }
        guard let man = json["Man"] as? String else { return nil }
        guard let mdl = json["Mdl"] as? String else { return nil }
        guard let mil = json["Mil"] as? Bool else { return nil }
        guard let mlat = json["Mlat"] as? Bool else { return nil }
        guard let op = json["Op"] as? String else { return nil }
        guard let opIcao = json["OpIcao"] as? String else { return nil }
        guard let posTime = json["PosTime"] as? Int else { return nil }
        guard let rcvr = json["Rcvr"] as? Int else { return nil }
        guard let reg = json["Reg"] as? String else { return nil }
        guard let spdTyp = json["SpdTyp"] as? Int else { return nil }
        guard let species = json["Species"] as? Int else { return nil }
        guard let sqk = json["Sqk"] as? String else { return nil }
        guard let tSecs = json["TSecs"] as? Int else { return nil }
        guard let tisb = json["Tisb"] as? Bool else { return nil }
        guard let trkH = json["TrkH"] as? Bool else { return nil }
        guard let trt = json["Trt"] as? Int else { return nil }
        guard let type = json["Type"] as? String else { return nil }
        guard let vsiT = json["VsiT"] as? Int else { return nil }
        guard let wTC = json["WTC"] as? Int else { return nil }
        guard let year = json["Year"] as? String else { return nil }
        let alt = json["Alt"] as? Int
        let from = json["From"] as? String
        let gAlt = json["GAlt"] as? Int
        let spd = Double(json: json, key: "Spd")
        let to = json["To"] as? String
        let trak = Double(json: json, key: "Trak")
        let vsi = json["Vsi"] as? Int
        self.init(alt: alt, altT: altT, bad: bad, brng: brng, cMsgs: cMsgs, cNum: cNum, call: call, callSus: callSus, cou: cou, dst: dst, engMount: engMount, engType: engType, engines: engines, fSeen: fSeen, flightsCount: flightsCount, from: from, gAlt: gAlt, gnd: gnd, hasPic: hasPic, hasSig: hasSig, help: help, icao: icao, id: id, inHg: inHg, interested: interested, lat: lat, long: long, man: man, mdl: mdl, mil: mil, mlat: mlat, op: op, opIcao: opIcao, posTime: posTime, rcvr: rcvr, reg: reg, spd: spd, spdTyp: spdTyp, species: species, sqk: sqk, tSecs: tSecs, tisb: tisb, to: to, trak: trak, trkH: trkH, trt: trt, type: type, vsi: vsi, vsiT: vsiT, wTC: wTC, year: year)
    }
}
