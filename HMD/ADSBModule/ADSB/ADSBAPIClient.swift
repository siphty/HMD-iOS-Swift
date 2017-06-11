//
//  ADSBAPIClient.swift
//  HMD
//
//  Created by Yi JIANG on 11/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import Foundation
import CoreLocation

enum APIRequestType{
    case post
    case put
    case get
}





public enum APICallBack<T> {
    case success(T)
    case error(NSError)
}

final class ADSBAPIClient {
    fileprivate static let adsbexchangeBaseUrl = "https://public-api.adsbexchange.com/VirtualRadar/AircraftList.json"
    
    func getAdsbExchangeAPIBaseUrl(_ url: String, with location: CLLocation, in radius: Int) -> String {
        let str = "\(ADSBAPIClient.adsbexchangeBaseUrl)/?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&fDstL=0&fDstU=\(radius)"
        return str
    }
    
    
}
