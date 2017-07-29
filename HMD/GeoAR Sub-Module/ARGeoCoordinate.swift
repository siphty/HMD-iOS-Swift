//
//  ARGeoCoordinate.swift
//  ADSB Radar
//
//  Created by Yi JIANG on 10/7/17.
//  Copyright © 2017 Siphty. All rights reserved.
//

import Foundation
import CoreLocation

class ARGeoCoordinate: NSObject {
    
    var dataObject : NSObject?
    var radialDistance: Double?
    var inclination: Double?
    var azimuth: Double?
    var geoLocation: CLLocation?
    
    override init() {
        dataObject = nil
        radialDistance = 0
        inclination = 0
        azimuth = 0
        geoLocation = nil
    }
    
    func degreesToRadians(_ x: Double) -> Double {
        return .pi * x / 180.0
    }
    
    func radiansToDegrees(_ x: Double) -> Double {
        return x * (180.0 / .pi)
    }
    
    func coordinate(with location: CLLocation) -> ARGeoCoordinate? {
        return nil
    }
    
    func getAngle(from first: CLLocationCoordinate2D, to second: CLLocationCoordinate2D) -> Float{
        let longitudinalDIfference = second.longitude - first.longitude
        let latitudinalDifference = second.latitude - first.latitude
        let possibleAzimuth: Float = Float((.pi * 0.5) - atan(latitudinalDifference / longitudinalDIfference))
        if longitudinalDIfference > 0 { return possibleAzimuth}
        else if longitudinalDIfference < 0 { return (possibleAzimuth) + .pi }
        else if latitudinalDifference < 0 { return .pi }
        return 0.0
        
    }
    
    func calibrate(using origin: CLLocation, _ useAltitude: Bool) {
        guard geoLocation != nil else { return }
        let baseDistance: Double = origin.distance(from: geoLocation!)
        radialDistance = sqrt(pow(origin.altitude - (geoLocation?.altitude)!, 2) + pow(baseDistance, 2))
        var angle = sin(abs(origin.altitude - (geoLocation?.altitude)!) / radialDistance!)
        if useAltitude {
            angle = 0
        }
        if origin.altitude > (geoLocation?.altitude)! {
            angle = -angle
        }
        inclination = angle
        azimuth = Double(getAngle(from: origin.coordinate, to: (geoLocation?.coordinate)!))
        
        
    }
    
//    func coordinate(with location: CLLocation) -> ARGeoCoordinate{
//        let newCoordinate: ARGeoCoordinate = ARGeoCoordinate()
//        newCoordinate.geoLocation = location
//        return newCoordinate
//    }
    
//    func hash() -> UInt {
//        return dataObject.hash + Int(radialDistance! + inclination! + azimuth!)
//    }
    
//    override func isEqual(_ other: NSObject?) -> Bool {
//        if other self {
//            return true
//        }
//        if !other || !(other is ARGeoCoordinate ) {
//            return false
//        }
//        return isEqual(to: other)
//    }
    
    func isEqual(to otherCoordinate: ARGeoCoordinate) -> Bool {
        if self == otherCoordinate { return true }
        
        var equal = radialDistance == otherCoordinate.radialDistance
        equal = equal && (inclination == otherCoordinate.inclination)
        equal = equal && (azimuth == otherCoordinate.azimuth)
        equal = equal && (dataObject == otherCoordinate.dataObject)
        return equal
    }
    
    fileprivate func description() -> String {
        return String(format: "r: %.3fm | φ: %.3f° | θ: %.3f°", radialDistance!, radiansToDegrees(azimuth!), radiansToDegrees(inclination!))
    }
}


