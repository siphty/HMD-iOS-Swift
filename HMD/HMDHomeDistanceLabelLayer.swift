//
//  HMDHomeDistanceLabelLayer.swift
//  HMD
//
//  Created by Yi JIANG on 31/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit

class HMDHomeDistanceLabelLayer: CATextLayer {
    var operationMode = misc.operationMode.Hover
    var distanceInKM: Int = 0
    var homeLocation: CLLocation?
    var aircraftLocation: CLLocation?
    
    //DJI key manager
    let aircraftLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
    let homeLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamHomeLocation)
    
    
    func setup() {
        switch operationMode {
        case .Camera, .Home:
            startUpdatingPhoneLocation()
        case .Cruise, .Hover, .Trans:
            startUpdatingLocation()
        }
    }
    
    
    func startUpdatingLocation() {
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftLocationKey!,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?)  in
                                                                guard let aLocation = newValue!.value  else {
                                                                    return
                                                                }
                                                                self.aircraftLocation = aLocation as? CLLocation
                                                                guard self.homeLocation != nil else { return }
                                                                let distance = self.aircraftLocation!.distance(from: self.homeLocation!)
                                                                print("H:\(self.formatDistance(distance))")
                                                                self.string = String("H:\(self.formatDistance(distance))")
        })
        
        
        DJISDKManager.keyManager()?.startListeningForChanges(on: homeLocationKey!,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?)  in
                                                                guard newValue != nil else { return }
                                                                guard let hLocation = newValue!.value as? CLLocation else {
                                                                    return
                                                                }
                                                                self.homeLocation = hLocation
                                                                guard self.aircraftLocation != nil else { return }
                                                                let distance = hLocation.distance(from: self.aircraftLocation!)
                                                                print("H:\(self.formatDistance(distance))")
                                                                self.string = String("H:\(self.formatDistance(distance))")
        })
    }
    
    func stopUpdatingAircraftSpeed() {
        DJISDKManager.keyManager()?.stopListening(on: aircraftLocationKey!, ofListener: self)
        DJISDKManager.keyManager()?.stopListening(on: homeLocationKey!, ofListener: self)
    }
    
    func startUpdatingPhoneLocation() {
        
    }
    
    func formatDistance(_ distance: CLLocationDistance) -> String {
        var distanceString: String?
        let distanceDouble: Double = distance
        if distanceDouble > 1000 {
            let distanceNumber = distanceDouble / 1000
            distanceString = String(format: "%.1f Km",distanceNumber )
        } else {
            distanceString = String(format: "%f m", distanceDouble)
        }
        return distanceString!
    }
    
    
}
