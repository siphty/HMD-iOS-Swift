//
//  CLLocation+Operator.swift
//  HMD
//
//  Created by Yi JIANG on 14/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import CoreLoaction

extension CLLocation{
    
    func updateLocation(_ location: CLLocation, with course: CLLocation.course) -> <#return type#> {
        <#function body#>
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

