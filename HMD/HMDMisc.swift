//
//  miscellaneous.swift
//  HMD
//
//  Created by Yi JIANG on 30/4/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class misc {
    
    
    /// Transform UIDeviceOrientation to CLDeviceOrientation
    ///
    /// - Parameter uiDeviceOrientation: UIDeviceOrientation enum
    /// - Returns: CLDeviceOrientation enum
    static public func getCLDeviceOrientation(by uiDeviceOrientation: UIDeviceOrientation) -> CLDeviceOrientation {
        switch uiDeviceOrientation {
        case .unknown:
            return CLDeviceOrientation.unknown
        case .portrait:
            return CLDeviceOrientation.portrait
        case .portraitUpsideDown:
            return CLDeviceOrientation.portraitUpsideDown
        case .landscapeLeft:
            return CLDeviceOrientation.landscapeLeft
        case .landscapeRight:
            return CLDeviceOrientation.landscapeRight
        case .faceUp:
            return CLDeviceOrientation.faceUp
        case .faceDown:
            return CLDeviceOrientation.faceDown
        }
    }
    
    enum operationMode {
        case Home
        case Hover
        case Cruise
        case Trans
    }
}



