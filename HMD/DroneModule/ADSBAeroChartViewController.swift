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
    let notificationCenter = NotificationCenter.default
    
    fileprivate var homeLocation: CLLocation? {
        didSet {
            ADSBAPIClient.sharedInstance.adsbLoction = homeLocation
        }
    }
    fileprivate var uavLocation: CLLocation?
    fileprivate var distanceBackToHome = Float()
    fileprivate var regionRadius: CLLocationDistance = 1000
    fileprivate var aircrafts: [ADSBAircraft]?
    fileprivate var expireSeconds: Int = 33
    
    fileprivate let kUAVAnnotationId   = "uav"
    fileprivate let kAircraftAnnotationId = "Aircraft"
    fileprivate let kAerodromeAnnotationId  = "Aerodrome"
    fileprivate let kRemoteAnnotationId  = "Remote"
    
    enum MapLockOn {
        case none
        case home
        case uav
        case aircraft
    }
    var mapLockOn = MapLockOn.home
    
    @IBOutlet weak var slideBar: UISlider!
    @IBAction func slideBarValueChanged(_ sender: Any) {
        
    }
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func uavButtomTouchUpInside(_ sender: Any) {
        mapLockOn = .uav
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
        
        //uav Location and Annotation
        startUpdatingUAVLocationData()
        startUpdatingUAVHeadingData()
        
        //Start updating aircrafts
        notificationCenter.addObserver(self,
                                       selector: #selector(aircraftListHasBeenUpdated),
                                       name: ADSBNotification.NewAircraftListKey,
                                       object: nil)
        let apiClient = ADSBAPIClient.sharedInstance
        apiClient.adsbLoction = homeLocation
        apiClient.startUpdateAircrafts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopUpdatingUAVAltitudeData()
        stopUpdatingUAVHeadingData()
        ADSBAPIClient.sharedInstance.stopUpdateAircrafts()
        notificationCenter.removeObserver(self, name: ADSBNotification.NewAircraftListKey, object: nil)
    }
    
    //Update DJI uav flight control details
    let uavLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation)
    func startUpdatingUAVLocationData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: uavLocationKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let uavLocation =  newValue!.value! as! CLLocation
                                                                self.UpdateAnnotation(self.kUAVAnnotationId, withLocation: uavLocation)
        })
    }
    func stopUpdatingUAVAltitudeData(){
        DJISDKManager.keyManager()?.stopListening(on: uavLocationKey!, ofListener: self)
    }
    
    let uavHeadingKey = DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading)
    func startUpdatingUAVHeadingData(){
        DJISDKManager.keyManager()?.startListeningForChanges(on: uavHeadingKey!,
                                                             withListener: self,
                                                             andUpdate: {(oldValue: DJIKeyedValue?, newValue: DJIKeyedValue?) in
                                                                if newValue == nil {
                                                                    return
                                                                }
                                                                let uavHeading =  newValue!.value! as! Double
                                                                self.UpdateAnnotation(self.kUAVAnnotationId, withHeading: uavHeading)
                                                                for anAnnotation in mapView.annotations {
                                                                    if anAnnotation is ADSBAnnotation {
                                                                        let theAnnotation = anAnnotation as! ADSBAnnotation
                                                                        theAnnotation.location.
                                                                        
                                                                        if theAnnotation.identifier == kUAVAnnotationId {
                                                                            var location = CLLocation(
                                                                        }
                                                                    }
                                                                }
        })
    }
    func stopUpdatingUAVHeadingData(){
        DJISDKManager.keyManager()?.stopListening(on: uavLocationKey!, ofListener: self)
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
                self.getAircraftDescription(adsbAnnotation.identifier, completion: { (aircraft) in
                    callout.stopLoading()
                    callout.titleLabel.text = aircraft?.icaoId ?? "NULL"
                })
                
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var theAnnotationView: ADSBAnnotationView?
        if annotation is ADSBAnnotation {
            let theAnnotation = annotation as! ADSBAnnotation
            if theAnnotation.identifier == kUAVAnnotationId {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartDroneIcon").rotatedByDegrees(degrees: CGFloat(theAnnotation.location.course), flip: false)!
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kUAVAnnotationId)
                }
            } else if theAnnotation.identifier.range(of: kAircraftAnnotationId) != nil {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartFlightIcon").rotatedByDegrees(degrees: CGFloat(theAnnotation.location.course), flip: false)!
//                theAnnotationView = mapView.view(for: theAnnotation) as? ADSBAnnotationView
                theAnnotationView =  mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: theAnnotation.identifier)
                }
            } else if theAnnotation.identifier == kAerodromeAnnotationId {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartRunwayIcon").rotatedByDegrees(degrees: CGFloat(theAnnotation.location.course), flip: false)!
                theAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: theAnnotation.identifier) as? ADSBAnnotationView
                if theAnnotationView == nil {
                    theAnnotationView = ADSBAnnotationView.init(annotation: theAnnotation, reuseIdentifier: kAerodromeAnnotationId)
                }
            } else {
                theAnnotation.image = #imageLiteral(resourceName: "AeroChartHomeBottom").rotatedByDegrees(degrees: CGFloat(theAnnotation.location.course), flip: false)!
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
            guard let annotation = exsitingAnnotation as? ADSBAnnotation else {
                continue
            }
            //If there is an annotation, update it.
            if annotation.identifier == identifier {
                //Just update location of the annotation in this stage
                
                let angleDiff: CGFloat = CGFloat(annotation.location.course - location.course)
                let annotationView =  mapView.view(for: annotation) as? ADSBAnnotationView
                if annotationView != nil {
                    annotationView?.annotationImageView?.transform = (annotationView?.annotationImageView?.transform.rotated(by:Geometric.degreeToRadian(angleDiff)))!
                    print("Angle: \(location.course)")
                }
                annotation.coordinate = location.coordinate
                annotation.location = location
                annotation.timeStamp = Date()
                return
            }
        }
        // there is no annotation have sameidentifiier
        let newAnnotation = createAnnotation(identifier, location: location)
        mapView.addAnnotation(newAnnotation)
    }
    
    
    func createAnnotation(_ identifier: String, location: CLLocation) -> ADSBAnnotation {
        let mapPin = ADSBAnnotation()
        // if the location services is on we will show the travel time, so we give a blank title to mapPin to draw a bigger callout for AnnotationView loader
        mapPin.title = String("TITLE")
        mapPin.identifier = identifier
        mapPin.subtitle = "subtitle"
        mapPin.coordinate = location.coordinate
        mapPin.location = location
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
    
    fileprivate func getAircraftDescription(_ identifier: String, completion : @escaping (_ aircraft: ADSBAircraft?) -> Void) {
        //Search aircraft list by identifier
        
        completion(nil)
    }
    
    fileprivate func getAircraftType(of identifier: String) -> String {
        return "normal airplane"
    }
    
    @objc func aircraftListHasBeenUpdated(){
        let aircraftList = ADSBCacheManager.sharedInstance.adsbAircrafts
        for aircraft in aircraftList {
            let annotationId = kAircraftAnnotationId + (aircraft.icaoId ?? "") + (aircraft.registration ?? "")
            if aircraft.latitude == nil || aircraft.longitude == nil { continue }
            let latitude = CLLocationDegrees(aircraft.latitude!)
            let longitude = CLLocationDegrees(aircraft.longitude!)
            let coordination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let altitude = CLLocationDistance(aircraft.gndPresAltitude ?? 0)
            let speed = CLLocationSpeed(aircraft.groundSpeed ?? 0)
            let heading = CLLocationDirection(aircraft.trackHeading ?? 0)
            UpdateAnnotation(annotationId, withLocation: CLLocation(coordinate: coordination,
                                                                    altitude: altitude,
                                                                    horizontalAccuracy: CLLocationAccuracy(10),
                                                                    verticalAccuracy:  CLLocationAccuracy(10),
                                                                    course: heading,
                                                                    speed: speed,
                                                                    timestamp: Date()) )
            
        }
        
    }
    
    //Remove all annotation
    func cleareExpiredAnnotation(){
        for anAnnotation in mapView.annotations {
            if anAnnotation is ADSBAnnotation {
                let theAnnotation = anAnnotation as! ADSBAnnotation
                let secondsInterval = Date.timeIntervalSince(theAnnotation.timeStamp)
                print("secondsInterval: \(secondsInterval)")
//                if secondsInterval > expireSeconds {
//                    mapView.removeAnnotation(theAnnotation)
//                }
            }
        }
    }
}







