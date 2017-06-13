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
    
    public var identifier: String = ""
    public var image: UIImage = UIImage()
    public var clusterAnnotation: ADSBAnnotation!
    public var containedAnnotations: [ADSBAnnotation]?
}
