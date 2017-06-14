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
    
    fileprivate let kAircraftAnnotationId   = "Aircraft"
    fileprivate let kFlightAnnotationId     = "Flight"
    fileprivate let kAerodromeAnnotationId  = "Aerodrome"
    
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
    @IBAction func remoteButtonTouchUpInside(_ sender: Any) {
        mapLockOn = .home
        if homeLocation == nil {
            return
        }
        centerMapOnLocation(homeLocation!)
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
        mapView.delegate = self
        
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
                                                                self.UpdateAnnotation(self.kAircraftAnnotationId, with: aircraftLocation)
        })
    }
    func stopUpdatingAircraftAltitudeData(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftLocationKey!, ofListener: self)
    }

}

//MARK: UIGestureRecognizerDelegate
extension ADSBAeroChartViewController: UIGestureRecognizerDelegate{
    
}

//MARK: MKMapViewDelegate
extension ADSBAeroChartViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
            return
        }
        if view.annotation is ADSBAnnotation {
            let adsbAnnotation = view.annotation as! ADSBAnnotation
            guard let callout: ADSBAnnotationCalloutView = (view as! ADSBAnnotationView).calloutView else { return }
            callout.titleLabel.text = "Test Label"
            if self.isLocationAvailabe() {
                callout.startLoading()
                self.getFlightDescription(adsbAnnotation.identifier, completion: { (flightDescription) in
                    callout.stopLoading()
                    callout.titleLabel.text = flightDescription.title
                })
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let theAnnotationView: ADSBAnnotationView
        if annotation is ADSBAnnotationView {
            let theAnnotation = annotation as! ADSBAnnotation
            if theAnnotation.identifier == kAircraftAnnotationId {
                theAnnotation.image = #imageLiteral(resourceName: "Drone Icon")
                theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAircraftAnnotationId)
            } else if theAnnotation.identifier.range(of: kFlightAnnotationId) != nil {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartFlightIcon")
                theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kFlightAnnotationId)
                
            } else if theAnnotation.identifier == kAerodromeAnnotationId {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartRunwayIcon")
                theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAerodromeAnnotationId)
            } else {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartHomeBottom")
                theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAerodromeAnnotationId)
            }
        } else if annotation is MKUserLocation {
            let theAnnotation = annotation as! MKUserLocation
            theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAerodromeAnnotationId)
        } else {
            return nil
        }
        return theAnnotationView
    }
}

//MARK: CLLocationManagerDelegate
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
        if homeLocation == nil {
            homeLocation = locations.last
            centerMapOnLocation(homeLocation!)
        } else {
        }
        
        
    }
}

//MARK: Miscellaneous
extension ADSBAeroChartViewController{
    func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func UpdateAnnotation(_ identifier: String, with location: CLLocation){
        //Check exsiting annotation with given annotation id.
        
        //If there is no such annotation, creat one.
        for exsitingAnnotation in mapView.annotations{
            guard let annotaion = exsitingAnnotation as? ADSBAnnotation else {
                continue
            }
            //If there is an annotation, update it.
            if annotaion.identifier == identifier {
                //Just update location of the annotation in this stage
                annotaion.coordinate = location.coordinate
                return
            }
        }
        // there is no annotation have sameidentifiier
        let newAnnotation = createAnnotation(identifier, with: location)
        mapView.addAnnotation(newAnnotation)
    }
    
    func createAnnotation(_ identifier: String, with location: CLLocation) -> ADSBAnnotation {
        let mapPin = ADSBAnnotation()
        mapPin.coordinate = location.coordinate
        mapPin.image = #imageLiteral(resourceName: "Tab Bar Drone")
        // if the location services is on we will show the travel time, so we give a blank title to mapPin to draw a bigger callout for AnnotationView loader
        mapPin.title = String("TITLE")
        mapPin.identifier = identifier
        mapPin.subtitle = "subtitle"
        return mapPin
    }
    
    
    // MARK: Location Services Helpers
    
    /// checks whehter user's has authorised the location services for this app or not
    ///
    /// - Returns: `true` if the user has authorised this app for using location services
    fileprivate func isLocationAuthorized() -> Bool {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        case .denied, .notDetermined, .restricted:
            return false
        }
    }
    /// checks  if the location services has been authorised and the location services is on
    ///
    /// - Returns: `true` if location services is on and the app has been authorised otherwise `false`
    fileprivate func isLocationAvailabe() -> Bool {
        return isLocationAuthorized() && CLLocationManager.locationServicesEnabled()
    }
    
    fileprivate func getFlightDescription(_ identifier: String, completion : @escaping (_ flightDescription: ADSBFlightDescription) -> Void) {
        
    }
    
    fileprivate func getFlightType(of identifier: String) -> String {
        return "normal airplane"
    }
}
