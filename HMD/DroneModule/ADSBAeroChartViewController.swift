//
//  ADSBAeroChartViewController.swift
//  HMD
//
//  Created by Yi JIANG on 8/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import MapKit
import DJISDK

class ADSBAeroChartViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    fileprivate var homeLocation: CLLocation?
    fileprivate var aircraftLocation: CLLocation?
    fileprivate var distanceBackToHome = Float()
    fileprivate var regionRadius: CLLocationDistance = 1000
    fileprivate let kAircraftAnnotationId = "Aircraft"
    
    enum MapLockOn {
        case none
        case home
        case aircraft
        case flight
    }
    var mapLockOn = MapLockOn.home
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func aircraftButtomTouchUpInside(_ sender: Any) {
        mapLockOn = .aircraft
    }
    @IBAction func homeButtonTouchUpInside(_ sender: Any) {
        mapLockOn = .home
        centerMapOnLocation(location: homeLocation!)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Home Location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        
        //Aircraft Location and Annotation
        startUpdatingAircraftLocationData()
        
        
    }

    func UpdateAircraftAnnotation(_ identity: String, with location: CLLocation){
//        for annotation in mapView.annotations {
////            if annotation. {
////                <#code#>
////            }
//        }
    }

    
    //Update DJI Aircraft flight control details
    let aircraftLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
    func startUpdatingAircraftLocationData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftLocationKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let aircraftLocation =  newValue!.value! as! CLLocation
                                                                self.UpdateAnnotation(kAircraftAnnotationId, with: aircraftLocation)
        })
    }
    func stopUpdatingAircraftAltitudeData(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftLocationKey!, ofListener: self)
    }

}
extension ADSBAeroChartViewController: UIGestureRecognizerDelegate{
    
}

extension ADSBAeroChartViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
}


extension ADSBAeroChartViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var isLocationAutorized = false
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            homeLocation = locationManager.location
            isLocationAutorized = true
        case .denied, .notDetermined, .restricted:
            isLocationAutorized = false
            homeLocation = nil
        }
        if !isLocationAutorized {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        homeLocation = locations.last
        if mapLockOn == .home {
            
            return
        } else {
        }
        
        
    }
}

extension ADSBAeroChartViewController{
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
