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
    
    func setAircraftIcon(){
        var imageName: String = ADSBAircraftType.none.rawValue
        guard (aircraft != nil) else {
            return
        }
        let wtc = ADSBWakeTurbulenceCategory(rawValue: aircraft?.wTC ?? 0)!
        let species = ADSBSpecies(rawValue: aircraft?.aircraftSpecies ?? 0)!
        let engineType = ADSBEngineType(rawValue: aircraft?.engineType ?? 0)!
//        let engineCount = aircraft?.engineCount ?? 1 //engineCount will alwasys be nil from ADSB responsed data
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
    
    
    
//    func getLayerHeight(by altitude: CGFloat, on layer: CALayer) -> CGFloat{
//        let maxiumAltitude: CGFloat = 40000.0
//        let scaleY = CGFloat(1 - sqrt(100 * altitude / maxiumAltitude) / 10) * layer.frame.height
//        return scaleY
//    }
    
//    image = (UIImage(named: imageName)!.maskWithColor(color: altitudeColor()))!
/// Test aircrat icon and details
//        var engineTypeString: String
//        switch engineType {
//        case .None:
//            engineTypeString = "Unknown"
//        case .Turbo:
//            engineTypeString = "Turbo"
//        case .Jet:
//            engineTypeString = "Jet"
//        case .Piston:
//            engineTypeString = "Piston"
//        case .Electric:
//            engineTypeString = "Electric"
//        }
//        let engineCountString: String = String( engineCount)
//        
//        var wtcString: String
//        switch wtc {
//        case .None:
//            wtcString = "Unknown"
//        case .Light:
//            wtcString = "Light"
//        case .Medium:
//            wtcString = "Medium"
//        case .Heavy:
//            wtcString = "Heavy"
//        }
//        var aircraftTypeString: String
//        if isHelicopter {
//            aircraftTypeString = "Helicopter"
//        } else if isFixedWing {
//            aircraftTypeString = "Plane"
//        } else if isGroundObject{
//            aircraftTypeString = "Ground Object"
//        } else { aircraftTypeString = "Unknown"}
//        
//        var militaryString: String
//        if isMilitary {
//            militaryString = "🚀"
//        } else {
//            militaryString = "🛩"
//        }
//        print("------------ Assign Image to Annotation \(String(describing: aircraft?.icaoId)) ----------------")
//        print("\(engineTypeString) \(engineCountString) Engine(s) \(wtcString) \(aircraftTypeString)    \(militaryString)")
//        print("\(imageName)")
//        print("---------------------------------------------------------------")
//    }
        
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
