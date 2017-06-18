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
    public var identifier: String = ""
    public var image: UIImage = UIImage()
    public var clusterAnnotation: ADSBAnnotation!
    public var containedAnnotations: [ADSBAnnotation]?
    
    public var location: CLLocation = CLLocation()
}
