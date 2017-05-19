//
//  ProductCommunicationManager.swift
//  SDK Swift Sample
//
//  Created by Arnaud Thiercelin on 3/22/17.
//  Copyright © 2017 DJI. All rights reserved.
//

import UIKit
import DJISDK

class ProductCommunicationManager: NSObject {

    // Set this value to true to use the app with the Bridge and false to connect directly to the product
    public let enableBridgeMode = true
    
    // When enableBridgeMode is set to true, set this value to the IP of your bridge app.
    public let bridgeAppIP = "10.0.0.20"
    
    var registered = false
    var connected = false
    
    
    func registerWithSDK() {
        let appKey = Bundle.main.object(forInfoDictionaryKey: SDK_APP_KEY_INFO_PLIST_KEY) as? String
        
        guard appKey != nil && appKey!.isEmpty == false else {
            NSLog("Please enter your app key in the info.plist")
            return
        }
        
        
            print("** App Key: \(appKey ?? "NULL")")
            print("** Bundle Id: \(Bundle.main.bundleIdentifier.debugDescription)")
    
        
        DJISDKManager.registerApp(with: self)
    }
    
}

extension ProductCommunicationManager : DJISDKManagerDelegate {
    func appRegisteredWithError(_ error: Error?) {
        if error != nil {
            registered = true
            print("SDK Registered with error: \(error.debugDescription)")
            print("** Bundle Id: \(Bundle.main.bundleIdentifier.debugDescription)")
            print("bundleIdentifier: \(Bundle.main.bundleIdentifier.debugDescription)")
        }
        
        if enableBridgeMode {
            print("******   Bridge Mode   ******")
            print("* Bridge IP: \(bridgeAppIP)*")
            DJISDKManager.enableBridgeMode(withBridgeAppIP: bridgeAppIP)
        } else {
            print("******   Direct Connect   ******")
            DJISDKManager.startConnectionToProduct()
        }
        
    }
    
    func productConnected(_ product: DJIBaseProduct?) {
        
    }
    
    func productDisconnected() {
        
    }
    
    func componentConnected(withKey key: String?, andIndex index: Int) {
        
    }
    
    func componentDisconnected(withKey key: String?, andIndex index: Int) {
        
    }
}
