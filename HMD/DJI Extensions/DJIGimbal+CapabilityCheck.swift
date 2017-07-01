//
//  DJIGimbal+CapabilityCheck.swift
//  HMD
//
//  Created by Yi JIANG on 1/7/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import DJISDK
import UIKit

extension DJIGimbal {
    func isFeatureSupported(by key: String) -> Bool{
        guard getCapability(with: key) != nil else {
            return false
        }
        return true
    }
    
    func getParamMin(by key: String) -> NSNumber? {
        guard let capability = capabilities[key] as? DJIParamCapability else {
            return nil
        }
        guard let capabilityMinMax = capability as? DJIParamCapabilityMinMax else { return nil }
        return capabilityMinMax.min
    }
    
    func getParamMax(by key: String) -> NSNumber? {
        guard let capability = capabilities[key] as? DJIParamCapability else {
            return nil
        }
        guard let capabilityMinMax = capability as? DJIParamCapabilityMinMax else { return nil }
        return capabilityMinMax.max
        
    }
    
    func getCapability(with key: String) -> DJIParamCapability? {
        if !capabilities.isEmpty && self.capabilities[key] != nil {
            return capabilities[key] as? DJIParamCapability
        }
        return nil
    }
}
