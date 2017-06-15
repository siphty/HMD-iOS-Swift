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
    fileprivate let kRemoteAnnotationId  = "Remote"
    
    enum MapLockOn {
        case none
        case home
        case aircraft
        case flight
    }
    var mapLockOn = MapLockOn.home
    
    @IBOutlet weak var slideBar: UISlider!
    @IBAction func slideBarValueChanged(_ sender: Any) {
        self.UpdateAnnotation("FlightABCDE", withHeading: Double(slideBar.value * 360))
    }
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func aircraftButtomTouchUpInside(_ sender: Any) {
        mapLockOn = .aircraft
        let randomLocation = CLLocation(latitude: (homeLocation?.coordinate.latitude)! + 0.0001 * Double(arc4random_uniform(100)),
                                        longitude: (homeLocation?.coordinate.longitude)! - 0.0001 * Double(arc4random_uniform(100)))
        
        let newAnnotation = createAnnotation("FlightABCDE", location: randomLocation, heading: 48, speed: 100)
        mapView.addAnnotation(newAnnotation)
    }
    
    @IBAction func remoteButtonTouchUpInside(_ sender: Any) {
        mapLockOn = .home
        if homeLocation == nil {
            return
        }
        centerMapOnLocation(homeLocation!)
        UpdateAnnotation("FlightABCDE", withHeading: Double(drand48() * 360))
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
        startUpdatingAircraftHeadingData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopUpdatingAircraftAltitudeData()
        stopUpdatingAircraftHeadingData()
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
                                                                self.UpdateAnnotation(self.kAircraftAnnotationId, withLocation: aircraftLocation)
        })
    }
    func stopUpdatingAircraftAltitudeData(){
        DJISDKManager.keyManager()?.stopListening(on: aircraftLocationKey!, ofListener: self)
    }
    
    let aircraftHeadingKey = DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading)
    func startUpdatingAircraftHeadingData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: aircraftHeadingKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let aircraftHeading =  newValue!.value! as! Double
                                                                self.UpdateAnnotation(self.kAircraftAnnotationId, withHeading: aircraftHeading)
        })
    }
    func stopUpdatingAircraftHeadingData(){
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
        var theAnnotationView: ADSBAnnotationView?
        if annotation is ADSBAnnotation {
            let theAnnotation = annotation as! ADSBAnnotation
            if theAnnotation.identifier == kAircraftAnnotationId {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartDroneIcon").rotatedByDegrees(degrees: theAnnotation.heading, flip: false)!
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAircraftAnnotationId)
                }
            } else if theAnnotation.identifier.range(of: kFlightAnnotationId) != nil {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartFlightIcon").rotatedByDegrees(degrees: theAnnotation.heading, flip: false)!
                theAnnotationView = mapView.view(for: theAnnotation) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: theAnnotation.identifier)
                }
            } else if theAnnotation.identifier == kAerodromeAnnotationId {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartRunwayIcon").rotatedByDegrees(degrees: theAnnotation.heading, flip: false)!
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAerodromeAnnotationId)
                }
            } else {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartHomeBottom").rotatedByDegrees(degrees: theAnnotation.heading, flip: false)!
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kRemoteAnnotationId)
                }
            }
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
    
    func UpdateAnnotation(_ identifier: String, withLocation location: CLLocation){
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
        let newAnnotation = createAnnotation(identifier, location: location, heading: 0, speed: 0)
        mapView.addAnnotation(newAnnotation)
    }
    
    
    func UpdateAnnotation(_ identifier: String, withHeading heading: Double){
        //Check exsiting annotation with given annotation id.
        
        //If there is no such annotation, creat one.
        for annotation in mapView.annotations{
            guard let annotation = annotation as? ADSBAnnotation else {
                continue
            }
            if annotation.identifier == identifier {
                let angleDiff = CGFloat(heading) - annotation.heading
                annotation.heading = CGFloat(heading)
                let annotationView =  mapView.view(for: annotation) as? ADSBAnnotationView
                if annotationView != nil {
                    annotationView?.annotationImageView?.transform = (annotationView?.annotationImageView?.transform.rotated(by:Geometric.degreeToRadian(angleDiff)))!
                    print("Angle: \(heading)")
                }
            }
        }
        
    }
    
    func createAnnotation(_ identifier: String, location: CLLocation, heading: Float, speed: Float) -> ADSBAnnotation {
        let mapPin = ADSBAnnotation()
        mapPin.image = #imageLiteral(resourceName: "testImage")
        // if the location services is on we will show the travel time, so we give a blank title to mapPin to draw a bigger callout for AnnotationView loader
        mapPin.title = String("TITLE")
        mapPin.identifier = identifier
        mapPin.subtitle = "subtitle"
        mapPin.coordinate = location.coordinate
        mapPin.heading = CGFloat(heading)
        mapPin.altitude = CGFloat(location.altitude)
        mapPin.speed = CGFloat(speed)
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
