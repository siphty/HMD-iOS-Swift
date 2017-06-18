//
//  CLLocation+Operator.swift
//  HMD
//
//  Created by Yi JIANG on 14/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation

extension CLLocation{
    
    func updateCourse(_ course: CLLocationDirection) -> CLLocation {
        let newLocation = CLLocation(coordinate: self.coordinate,
                                      altitude: self.altitude,
                                      horizontalAccuracy: self.horizontalAccuracy,
                                      verticalAccuracy:  self.verticalAccuracy,
                                      course: course,
                                      speed: self.speed,
                                      timestamp: self.timestamp)
        return newLocation
    }
}


func != (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (Double(lhs.latitude) != Double(rhs.latitude)) || (Double(lhs.longitude) != Double(rhs.longitude))
}

func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    return (Double(lhs.latitude) == Double(rhs.latitude)) || (Double(lhs.longitude) == Double(rhs.longitude))
}

//func - (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Float {
//    return (Double(lhs.latitude) != Double(rhs.latitude)) || (Double(lhs.longitude) != Double(rhs.longitude))
//}

