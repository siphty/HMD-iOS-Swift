//
//  ADSBMiscellanious.swift
//  HMD
//
//  Created by Yi JIANG on 14/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation



public struct ADSBFlightDescription {
    public var owner: String
    public var size: Double
    public var passenger: Int
    public let title: String
    public let subtitle: String
    public init(owner: String ,size: Double, passenger: Int , title: String, subtitle: String) {
        self.owner = owner
        self.size = size
        self.passenger = passenger
        self.title = title
        self.subtitle = subtitle
    }
    
}
