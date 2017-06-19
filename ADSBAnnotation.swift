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
    var aircraft: ADSBAircraft?
}
