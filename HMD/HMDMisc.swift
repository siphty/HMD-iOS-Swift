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
        //Home mode: the operator view on the ground.
        case Home
        
        //Hover mode: operator using HMD to control gimbal and drone, and drone is hovering in the sky. 
        case Hover
        
        //Cruise mode: drone cruising by mission, Operator can use HMD to control gimbal and drone body, but not the path of cruise.
        case Cruise
        
        //Transition mode: HMD can only control gimbal, but not the drone body. Operator needs use remote to control flight path.
        case Trans
    }
}

public struct  HMDColor {
    static let scale = UIColor.init(red: 35.0 / 255.0, green: 255.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor
    static let normalIndicator = UIColor.init(red: 35.0 / 255.0, green: 255.0 / 255.0, blue: 35.0 / 255.0, alpha: 1).cgColor
}





