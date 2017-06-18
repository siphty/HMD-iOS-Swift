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
//    dynamic var coordinate : CLLocationCoordinate2D
    public var identifier: String = ""
    public var image: UIImage = UIImage()
    public var clusterAnnotation: ADSBAnnotation!
    public var containedAnnotations: [ADSBAnnotation]?
    public var heading: CGFloat = CGFloat()
    public var altitude: CGFloat = CGFloat()
    public var speed: CGFloat = CGFloat()
    public var watchDog: Int = 3
}
