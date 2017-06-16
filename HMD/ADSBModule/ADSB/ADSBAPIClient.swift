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
    var scanDistance: Float = 10
    
    fileprivate let adsbexchangeBaseUrl = "http://public-api.adsbexchange.com/VirtualRadar/AircraftList.json"
    fileprivate var requestTimer: Timer?
    fileprivate var isLastResponseProceseed: Bool = true
    
    func startUpdateFlights(){
        if requestTimer == nil {
            requestTimer =  Timer.scheduledTimer(
                timeInterval: TimeInterval(10),
                target      : self,
                selector    : #selector(updateFlights),
                userInfo    : nil,
                repeats     : true)
        }
    }
    
    func stopUpdateFlights(){
        requestTimer?.invalidate()
    }
    
    func updateLocation(_ location: CLLocation) {
        adsbLoction = location
    }
    
    
    func makeRequestUrl(with location: CLLocation, in radius: Float) -> String {
        return  "\(adsbexchangeBaseUrl)?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&fDstL=0&fDstU=\(radius)"
    }
    
    func requestADSBExChange(_ url: URL, handle complition: @escaping (_ flightsArray: [ADSBXResponse.AcList]?, _ error: Error?) -> Void){
        if !isLastResponseProceseed { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("value", forHTTPHeaderField: "Key")
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {data, response, error in
            if error != nil {
                print("Error from URL session data task: \(error.debugDescription)")
                print("Response: \(response.debugDescription)")
                return
            }
            self.isLastResponseProceseed = false
            print("data: \(String(describing: data?.description))")
            do {
                let json: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                let dataObj: ADSBXResponse = ADSBXResponse.init(json: json)!
                print("response: \(json.debugDescription)")
                print("response: \(String(describing: json["acList"]))")
                let adsbFlights: [ADSBXResponse.AcList] = dataObj.acList
                for flight in adsbFlights {
                     print("flights: \(flight.icao)")
                }
                print("flights above: \(adsbFlights.count)")
                if adsbFlights.count < 5 {
                    self.scanDistance = self.scanDistance + 5
                } else if adsbFlights.count > 20 {
                    self.scanDistance = self.scanDistance - 5
                    if self.scanDistance < 10 {
                        self.scanDistance = 10
                    }
                }
                complition(adsbFlights, nil)
            } catch let error {
                complition(nil, error)
            }
            self.isLastResponseProceseed = true
        })
        
        task.resume()
    }
    
    func getFlights(on location: CLLocation, in distance: Float){
        
        //Compile http request URL
        let urlSting = makeRequestUrl(with: location, in: distance)
        guard let url = URL(string: urlSting) else {
            print("URL string can't be parsed")
            return
        }
        requestADSBExChange(url, handle: { (flightsArray, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            print("Flights Array: \(String(describing: flightsArray))")
            
            })
        
    }
    
    @objc func updateFlights(){
        guard (adsbLoction != nil) else {
            print("Location is not been set")
            return
        }
        getFlights(on: adsbLoction!, in: scanDistance)
    }
    
}


