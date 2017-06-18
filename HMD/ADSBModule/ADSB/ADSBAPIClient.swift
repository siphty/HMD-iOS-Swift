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

final class ADSBAPIClient {
    static let sharedInstance = ADSBAPIClient()
    private init(){}
    var adsbLoction: CLLocation?
    var scanDistance: Float = 40   // KM
    var scanFrequency: Int = 7
    
    fileprivate let adsbexchangeBaseUrl = "http://public-api.adsbexchange.com/VirtualRadar/AircraftList.json"
    fileprivate var requestTimer: Timer?
    fileprivate var isLastResponseProceseed: Bool = true
    fileprivate var isUpdatingAircrafts: Bool = false
    func makeRequestUrl(with location: CLLocation, in radius: Float) -> String {
        return  "\(adsbexchangeBaseUrl)?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&fDstL=0&fDstU=\(radius)"
    }
    
    func updateLocation(_ location: CLLocation) {
        adsbLoction = location
    }
    
    func stopUpdateAircrafts(){
        requestTimer?.invalidate()
        isUpdatingAircrafts = false
    }
    
    func startUpdateAircrafts(){
        if isUpdatingAircrafts { return }
        updateAircrafts()
        if requestTimer == nil {
            requestTimer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(scanFrequency),
                target      : self,
                selector    : #selector(updateAircrafts),
                userInfo    : nil,
                repeats     : true)
        }
        isUpdatingAircrafts = true
    }
    
    @objc func updateAircrafts(){
        guard (adsbLoction != nil) else {
            print("Location has not been set")
            return
        }
        let urlSting = makeRequestUrl(with: adsbLoction!, in: scanDistance)
        guard let url = URL(string: urlSting) else {
            print("URL string can't be parsed")
            return
        }
        requestADSBExChange(url, handle: { (aircraftsArray, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            ADSBCacheManager.sharedInstance.adsbAircrafts = aircraftsArray
        })
    }
    
    
    func requestADSBExChange(_ url: URL, handle complition: @escaping (_ aircraftsArray: [ADSBAircraft], _ error: Error?) -> Void){
        if !isLastResponseProceseed { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("value", forHTTPHeaderField: "Key")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            if error != nil {
                print("Error from URL session data task: \(error.debugDescription)")
                return
            }
            self.isLastResponseProceseed = false
            do {
                let responseDict: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let adsbXResponseObj: ADSBXResponse = ADSBXResponse.init(responseDict: responseDict)!
                guard let adsbAircrafts = adsbXResponseObj.aircraftList else { return }
                print("Aircrafts above: \(adsbAircrafts.count)")
                if adsbAircrafts.count < 5 {
                    self.scanDistance = self.scanDistance + 5
                } else if adsbAircrafts.count > 35 {
                    self.scanDistance = self.scanDistance - 5
                    if self.scanDistance < 10 {
                        self.scanDistance = 10
                    }
                }
                print("Next Scan range: \(self.scanDistance)")
                complition(adsbAircrafts, nil)
            } catch let error {
                complition([], error)
            }
            self.isLastResponseProceseed = true
        })
        task.resume()
    }
    
    
    
}


