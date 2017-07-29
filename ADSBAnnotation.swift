//
//  ADSBAnnotation.swift
//  HMD
//
//  Created by Yi JIANG on 13/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import MapKit

open class ADSBAnnotation: MKPointAnnotation {
//    override dynamic open var coordinate : CLLocationCoordinate2D
    var identifier: String = ""
    var image: UIImage = UIImage()
    var clusterAnnotation: ADSBAnnotation!
    var containedAnnotations: [ADSBAnnotation]?
    var location: CLLocation?
    var aircraft: ADSBAircraft? {
        didSet{
            setAircraftIcon()
        }
    }
    
    //ARAnnotation
    /// View for annotation. It is set inside ARViewController after fetching view from dataSource.
    internal(set) open var annotationView: ARAnnotationView?
    // Internal use only, do not set this properties
    internal(set) open var distanceFromUser: Double = 0
    internal(set) open var azimuth: Double = 0
    internal(set) open var inclination: Double = 0
    //    internal(set) open var verticalLevel: Int = 0
    internal(set) open var active: Bool = false
    
    
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
        guard aircraft != nil,
            aircraft?.presAltitude != nil,
            aircraft?.ViewerDistance != nil,
            aircraft?.ViewerBearing != nil   else {
                guard location != nil else { return }
                let baseDistance: Double = origin.distance(from: location!)
                distanceFromUser = sqrt(pow(origin.altitude - (location?.altitude)!, 2) + pow(baseDistance, 2))
                azimuth = Double(getAngle(from: origin.coordinate, to: (location?.coordinate)!))
                return
        }
        
        azimuth = (aircraft?.ViewerBearing)!
        distanceFromUser = (aircraft?.ViewerDistance)!
        
        var radius = atan(abs(origin.altitude - (location?.altitude)!) / (distanceFromUser * 3280.84)  )
        if !useAltitude {
            radius = 0
        }
        inclination = radius  * (180.0 / .pi)
    }
    func setAircraftIcon(){
        var imageName: String = ADSBAircraftType.none.rawValue
        guard (aircraft != nil) else {
            return
        }
        let wtc = ADSBWakeTurbulenceCategory(rawValue: aircraft?.wTC ?? 0)!
        let species = ADSBSpecies(rawValue: aircraft?.aircraftSpecies ?? 0)!
        let engineType = ADSBEngineType(rawValue: aircraft?.engineType ?? 0)!
        let isMilitary = aircraft?.isMilitary ?? false
        var isFixedWing: Bool = true
        var isHelicopter: Bool = false
        var isGroundObject: Bool = false
        switch species {
        case .None, .LandPlane, .SeaPlane, .Amphibian:
            isFixedWing = true
            isGroundObject = !isFixedWing
            isHelicopter = !isFixedWing
        case .Helicopter, .Gyrocopter, .Tiltwing:
            isHelicopter = true
            isFixedWing = !isHelicopter
            isGroundObject = !isHelicopter
        case .GroundVehicle, .Tower:
            isGroundObject = true
            isFixedWing = !isGroundObject
            isHelicopter = !isGroundObject
        }
   
        if isGroundObject {
            if aircraft?.aircraftSpecies == ADSBSpecies.GroundVehicle.rawValue {
                imageName = ADSBAircraftType.groundVehicle.rawValue
            } else if aircraft?.aircraftSpecies == ADSBSpecies.Tower.rawValue {
                imageName = ADSBAircraftType.tower.rawValue
            }
        }else if isMilitary {
            imageName = ADSBAircraftType.militaryJet.rawValue
            
            
        }else if engineType == .Jet && wtc == .Light && isFixedWing && !isGroundObject{
            imageName = ADSBAircraftType.jetTwoEngLight.rawValue
            
        }else if engineType == .Jet && wtc == .Medium && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.jetTwoEngMediumC.rawValue
            
        }else if engineType == .Jet && wtc == .Heavy && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.jetFourEngHeavy.rawValue
            
        }else if engineType == .Jet && wtc == .None && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.jetFourEngMedium.rawValue
            
            
        }else if engineType == .Turbo && wtc == .Light && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.pistonTwoEngLight.rawValue
            
        }else if engineType == .Turbo && wtc == .Medium && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.turboTwoEngMedium.rawValue
            
        }else if engineType == .Turbo && wtc == .Heavy && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.turboTwoEngHeavy.rawValue
            
        }else if engineType == .Turbo && wtc == .None && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.pistonTwoEngLight.rawValue
            
            
            
        }else if engineType == .Piston && wtc == .Light && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.pistonOneEngLight.rawValue
            
        }else if engineType == .Piston && wtc == .Medium && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.pistonTwoEngLight.rawValue
            
        }else if engineType == .Piston && wtc == .Heavy && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.turboTwoEngMedium.rawValue
            
        }else if engineType == .Piston && wtc == .None && isFixedWing && !isGroundObject {
            imageName = ADSBAircraftType.pistonTwoEngLight.rawValue // I can't find 2 piston engines heavy plane's top view png file
            
        }else if isHelicopter && !isGroundObject && wtc == .Light {
            imageName = ADSBAircraftType.heliLight.rawValue
            
        }else if isHelicopter && !isGroundObject && wtc == .Medium {
            imageName = ADSBAircraftType.heliMedium.rawValue
            
        }else if isHelicopter && !isGroundObject && wtc == .Heavy {
            imageName = ADSBAircraftType.heliHeavy.rawValue
        }else {
            imageName = ADSBAircraftType.none.rawValue
        }
        image = (UIImage(named: imageName))!//.maskWithColor(color: UIColor.red)!
    }
        
}
