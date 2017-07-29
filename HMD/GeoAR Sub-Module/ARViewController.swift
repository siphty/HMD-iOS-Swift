//
//  ARViewController.swift
//  HDAugmentedRealityDemo
//
//  Created by Yi JIANG on 19/7/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

/**
 *      Augmented reality view controller.
 *
 *      How to use:
 *      1. Initialize controller and set datasource(and other properties if needed)
 *      2. Use setAnnotations method to set annotations
 *      3. Present controller modally
 *      4. Implement ARDataSource to provide annotation views in your data source
 *
 *      Properties maxVerticalLevel, maxVisibleAnnotations and maxDistance can be used to optimize performance.
 *      Use trackingManager.userDistanceFilter and trackingManager.reloadDistanceFilter to set how often data is refreshed/reloaded.
 *      All properties are documented.
 *
 */
open class ARViewController: UIViewController, ARTrackingManagerDelegate
{
    /// Data source
    open weak var dataSource: ARDataSource?
    /// Orientation mask for view controller. Make sure orientations are enabled in project settings also.
    open var interfaceOrientationMask: UIInterfaceOrientationMask = UIInterfaceOrientationMask.all
    /// Total maximum number of visible annotation views. Default value is 100. Max value is 500
    open var maxVisibleAnnotations = 0
        {
        didSet
        {
            if(maxVisibleAnnotations > MAX_VISIBLE_ANNOTATIONS)
            {
                maxVisibleAnnotations = MAX_VISIBLE_ANNOTATIONS
            }
        }
    }
    /**
     *       Maximum distance(in meters) for annotation to be shown.
     *       If the distance from annotation to user's location is greater than this value, than that annotation will not be shown.
     *       Also, this property, in conjunction with maxVerticalLevel, defines how are annotations aligned vertically. Meaning
     *       annotation that are closer to this value will be higher.
     *       Default value is 0 meters, which means that distances of annotations don't affect their visiblity.
     */
    open var maxDistance: Double = 0
    /// Class for managing geographical calculations. Use it to set properties like reloadDistanceFilter, userDistanceFilter and altitudeSensitive
    fileprivate(set) open var trackingManager: ARTrackingManager = ARTrackingManager()
    
    open var closeButtonImage: UIImage?
    {
        didSet
        {
            closeButton?.setImage(self.closeButtonImage, for: UIControlState())
        }
    }
    /// Enables map debugging and some other debugging features, set before controller is shown
    @available(*, deprecated, message: "Will be removed in next version, use uiOptions.debugEnabled.")
    open var debugEnabled = false
    {
        didSet
        {
            self.uiOptions.debugEnabled = debugEnabled
        }
    }
    /**
     Smoothing factor for heading in range 0-1. It affects horizontal movement of annotaion views. The lower the value the bigger the smoothing.
     Value of 1 means no smoothing, should be greater than 0.
     */
    open var headingSmoothingFactor: Double = 1
    
    /**
     Called every 5 seconds after location tracking is started but failed to deliver location. It is also called when tracking has just started with timeElapsed = 0.
     The timer is restarted when app comes from background or on didAppear.
     */
    open var onDidFailToFindLocation: ((_ timeElapsed: TimeInterval, _ acquiredLocationBefore: Bool) -> Void)?
    
    /**
     Some ui options. Set it before controller is shown, changes made afterwards are disregarded.
     */
    open var uiOptions = UiOptions()
    
    let notificationCenter = NotificationCenter.default
    
    //MARK: Private
    fileprivate var initialized: Bool = false
    fileprivate var cameraSession: AVCaptureSession = AVCaptureSession()
    fileprivate var overlayView: OverlayView = OverlayView()
    fileprivate var displayTimer: CADisplayLink?
    fileprivate var cameraLayer: AVCaptureVideoPreviewLayer?    // Will be set in init
    fileprivate var annotationViews: [ARAnnotationView] = []
    fileprivate var previosRegion: Int = 0
    fileprivate var degreesPerScreen: CGFloat = 0
    fileprivate var shouldReloadAnnotations: Bool = false
    fileprivate var reloadInProgress = false
    fileprivate var reloadToken: Int = 0
    fileprivate var reloadLock = NSRecursiveLock()
    fileprivate var annotations: [ADSBAnnotation] = []
    fileprivate var activeAnnotations: [ADSBAnnotation] = []
    fileprivate var closeButton: UIButton?
    fileprivate var currentHeading: Double = 0
    fileprivate var lastLocation: CLLocation?

    fileprivate var debugLabel: UILabel?
    fileprivate var debugMapButton: UIButton?
    fileprivate var didLayoutSubviews: Bool = false
    
    // MARK: -
    // MARK: Init
   
    init()
    {
        super.init(nibName: nil, bundle: nil)
        self.initializeInternal()
    }
    
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.initializeInternal()
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeInternal()
        
    }
    
    internal func initializeInternal()
    {
        if self.initialized
        {
            return
        }
        self.initialized = true;
        
        // Default values
        self.trackingManager.delegate = self
//        self.maxVerticalLevel = 5
        self.maxVisibleAnnotations = 20
        self.maxDistance = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(ARViewController.appWillEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ARViewController.appDidEnterBackground(_:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        self.initialize()
    }
    
    /// Intended for use in subclasses, no need to call super
    internal func initialize()
    {
        
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
        stopCamera()
    }
    
    // MARK: -
    // MARK: View's lifecycle
    open override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        onViewWillAppear()  // Doing like this to prevent subclassing problems
    }
    
    open override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        notificationCenter.addObserver(self,
                                       selector: #selector(aircraftListHasBeenUpdated),
                                       name: ADSBNotification.NewAircraftListKey,
                                       object: nil)
        ADSBAPIClient.sharedInstance.startUpdateAircrafts(every: 1.6, range: 25)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        ADSBAPIClient.sharedInstance.stopUpdateAircrafts()
        notificationCenter.removeObserver(ADSBNotification.NewAircraftListKey)
    }
    
    open override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        stopCamera()
    }
    
    open override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        onViewDidLayoutSubviews()
    }
    
    fileprivate func onViewWillAppear()
    {
        // Camera layer if not added
        if self.cameraLayer?.superlayer == nil { self.loadCamera() }
        
        // Overlay
        if self.overlayView.superview == nil { self.loadOverlay() }
        
        // Set orientation and start camera
        setOrientation(UIApplication.shared.statusBarOrientation)
        layoutUi()
        startCamera(notifyLocationFailure: true)
    }
    
    
    internal func closeButtonTap()
    {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    open override var prefersStatusBarHidden : Bool
    {
        return true
    }
    
    fileprivate func onViewDidLayoutSubviews()
    {
        // Executed only first time when everything is layouted
        if !didLayoutSubviews
        {
            didLayoutSubviews = true
            
            // Close button
            if uiOptions.closeButtonEnabled { self.addCloseButton() }
            
            // Layout
            layoutUi()
            
            view.layoutIfNeeded()
        }
        
        degreesPerScreen = (view.bounds.size.width / OVERLAY_VIEW_WIDTH) * 360.0
        
        
    }
    internal func appDidEnterBackground(_ notification: Notification)
    {
        if(view.window != nil)
        {
            trackingManager.stopTracking()
        }
    }
    internal func appWillEnterForeground(_ notification: Notification)
    {
        if(view.window != nil)
        {
            // Removing all from screen and restarting location manager.
            for annotation in annotations
            {
                annotation.annotationView = nil
            }
            
            for annotationView in annotationViews
            {
                annotationView.removeFromSuperview()
            }
            
            annotationViews = []
            shouldReloadAnnotations = true;
            trackingManager.stopTracking()
            // Start tracking
            trackingManager.startTracking(notifyLocationFailure: true)
        }
    }
    
    // MARK: -
    // MARK: Annotations and annotation views
    /**
     *       Sets annotations. Note that annotations with invalid location will be kicked.
     *
     *       - parameter annotations: Annotations
     */
    open func setAnnotations(_ annotations: [ADSBAnnotation])
    {
        var validAnnotations: [ADSBAnnotation] = []
        // Don't use annotations without valid location
        for annotation in annotations
        {
            if annotation.location != nil && CLLocationCoordinate2DIsValid(annotation.location!.coordinate)
            {
                validAnnotations.append(annotation)
            }
        }
        self.annotations = validAnnotations
        reloadAnnotations()
    }
    
    open func getAnnotations() -> [ADSBAnnotation]
    {
        return annotations
    }
    
    /// Creates annotations views and recalculates all variables(distances, azimuths, vertical levels) if user location is available, else it will reload when it gets user location.
    open func reloadAnnotations()
    {
        if trackingManager.userLocation != nil && isViewLoaded
        {
            shouldReloadAnnotations = false
            reload(calculateDistanceAndAzimuth: true, calculateVerticalLevels: true, createAnnotationViews: true)
        }
        else
        {
            shouldReloadAnnotations = true
        }
    }
    
    /// Creates annotation views. All views are created at once, for active annotations. This reduces lag when rotating.
    fileprivate func createAnnotationViews()
    {
        var annotationViews: [ARAnnotationView] = []
        let activeAnnotations = self.activeAnnotations  // Which annotations are active is determined by number of properties - distance, vertical level etc.
        
        // Removing existing annotation views
        for annotationView in annotationViews
        {
            annotationView.removeFromSuperview()
        }
        
        // Destroy views for inactive anntotations
        for annotation in annotations
        {
            if(!annotation.active)
            {
                annotation.annotationView = nil
            }
        }
        
        // Create views for active annotations
        for annotation in activeAnnotations
        {
            // Don't create annotation view for annotation that doesn't have valid location. Note: checked before, should remove
            if annotation.location == nil || !CLLocationCoordinate2DIsValid(annotation.location!.coordinate)
            {
                continue
            }
            
            var annotationView: ARAnnotationView? = nil
            if annotation.annotationView != nil
            {
                annotationView = annotation.annotationView
            }
            else
            {
                annotationView = dataSource?.ar(self, viewForAnnotation: annotation)
            }
            
            if annotationView != nil
            {
                annotation.annotationView = annotationView
                annotationView!.annotation = annotation
                annotationViews.append(annotationView!)
            }
        }
        
        self.annotationViews = annotationViews
    }
    
    
    fileprivate func calculateDistanceAndAzimuthForAnnotations(sort: Bool, onlyForActiveAnnotations: Bool)
    {
        if trackingManager.userLocation == nil
        {
            return
        }
        
        let userLocation = trackingManager.userLocation!
        let array = (onlyForActiveAnnotations && activeAnnotations.count > 0) ? activeAnnotations : annotations
        
        for annotation in array
        {
            guard annotation.location != nil else {// This should never happen bcs we remove all annotations with invalid location in
                annotation.distanceFromUser = 0
                annotation.azimuth = 0
                continue
            }
            annotation.calibrate(using: userLocation, true)
        }
        
        if sort
        {
            //annotations = annotations.sorted { $0.distanceFromUser < $1.distanceFromUser }
            
            let sortedArray: NSMutableArray = NSMutableArray(array: annotations)
            let sortDesc = NSSortDescriptor(key: "distanceFromUser", ascending: true)
            sortedArray.sort(using: [sortDesc])
            self.annotations = sortedArray as [AnyObject] as! [ADSBAnnotation]
        }
    }
    
    fileprivate func updateAnnotationsForCurrentHeading()
    {
        //===== Removing views not in viewport, adding those that are. Also removing annotations view vertical level > maxVerticalLevel
        let degreesDelta = Double(degreesPerScreen)
        
        for annotationView in self.annotationViews
        {
            if annotationView.annotation != nil
            {
                let delta = deltaAngle(currentHeading, angle2: annotationView.annotation!.azimuth)
                
                if fabs(delta) < degreesDelta// && annotationView.annotation!.verticalLevel <= self.maxVerticalLevel
                {
                    if annotationView.superview == nil
                    {
                        overlayView.addSubview(annotationView)
                    }
                }
                else
                {
                    if annotationView.superview != nil
                    {
                        annotationView.removeFromSuperview()
                    }
                }
            }
        }
        
        //===== Fix position of annoations near Norh(critical regions). Explained in xPositionForAnnotationView
        let threshold: Double = 40
        var currentRegion: Int = 0
        
        if currentHeading < threshold // 0-40
        {
            currentRegion = 1
        }
        else if currentHeading > (360 - threshold)    // 320-360
        {
            currentRegion = -1
        }
        
        if currentRegion != self.previosRegion
        {
            if annotationViews.count > 0
            {
                // This will just call positionAnnotationViews
                reload(calculateDistanceAndAzimuth: false, calculateVerticalLevels: false, createAnnotationViews: false)
            }
        }
        
        previosRegion = currentRegion
    }
    
    
    
    fileprivate func positionAnnotationViews()
    {
        for annotationView in annotationViews
        {
            let x = xPositionForAnnotationView(annotationView, heading: trackingManager.heading)
            let y = yPositionForAnnotationView(annotationView)
            
            annotationView.frame = CGRect(x: x, y: y, width: annotationView.bounds.size.width, height: annotationView.bounds.size.height)
        }
    }
    
    fileprivate func xPositionForAnnotationView(_ annotationView: ARAnnotationView, heading: Double) -> CGFloat
    {
        guard let annotation = annotationView.annotation else { return 0 }
        
        // Azimuth
        let azimuth = annotation.azimuth
        
        // Calculating x position
        var xPos: CGFloat = CGFloat(azimuth) * H_PIXELS_PER_DEGREE - annotationView.bounds.size.width / 2.0
        
        // Fixing position in critical areas (near north).
        // If current heading is right of north(< 40), annotations that are between 320 - 360 wont be visible so we change their position so they are visible.
        // Also if current heading is left of north (320 - 360), annotations that are between 0 - 40 wont be visible so we change their position so they are visible.
        // This is needed because all annotation view are on same overlay view so views at start and end of overlay view cannot be visible at the same time.
        let threshold: Double = 40
        if heading < threshold
        {
            if annotation.azimuth > (360 - threshold)
            {
                xPos = -(OVERLAY_VIEW_WIDTH - xPos);
            }
        }
        else if heading > (360 - threshold)
        {
            if annotation.azimuth < threshold
            {
                xPos = OVERLAY_VIEW_WIDTH + xPos;
            }
        }
        return xPos
    }
    
    fileprivate func yPositionForAnnotationView(_ annotationView: ARAnnotationView) -> CGFloat
    {
        guard let annotation = annotationView.annotation else { return 0 }
        let inclination = annotation.inclination
//        let yPos: CGFloat = VERTICAL_SENS / 2 - (CGFloat(inclination) * H_PIXELS_PER_DEGREE)
        let yPos: CGFloat = self.view.bounds.size.height - (CGFloat(inclination) * H_PIXELS_PER_DEGREE) - 44
        return yPos
    }
    
   
    
    fileprivate func getAnyAnnotationView() -> ARAnnotationView?
    {
        var anyAnnotationView: ARAnnotationView? = nil
        
        if let annotationView = annotationViews.first
        {
            anyAnnotationView = annotationView
        }
        else if let annotation = activeAnnotations.first
        {
            anyAnnotationView = dataSource?.ar(self, viewForAnnotation: annotation)
        }
        
        return anyAnnotationView
    }
    
    // MARK: -
    // MARK: Main logic
    fileprivate func reload(calculateDistanceAndAzimuth: Bool, calculateVerticalLevels: Bool, createAnnotationViews: Bool)
    {
        if calculateDistanceAndAzimuth
        {
            
            // Sort by distance is needed only if creating new views
            let sort = createAnnotationViews
            // Calculations for all annotations should be done only when creating annotations views
            let onlyForActiveAnnotations = !createAnnotationViews
            calculateDistanceAndAzimuthForAnnotations(sort: sort, onlyForActiveAnnotations: onlyForActiveAnnotations)
            
            
        }
        
        if(createAnnotationViews)
        {
            activeAnnotations = filteredAnnotations(nil, maxVisibleAnnotations: maxVisibleAnnotations, maxDistance: maxDistance)
//            setInitialVerticalLevels()
        }
        
        if calculateVerticalLevels
        {
//            calculateVerticalLevels()
            
        }
        
        if createAnnotationViews
        {
            self.createAnnotationViews()
        }
        
        positionAnnotationViews()
        
        // Calling bindUi on every annotation view so it can refresh its content,
        // doing this every time distance changes, in case distance is needed for display.
        if calculateDistanceAndAzimuth
        {
            for annotationView in annotationViews
            {
                annotationView.bindUi()
            }
        }
        
    }
    
    /// Determines which annotations are active and which are inactive. If some of the input parameters is nil, then it won't filter by that parameter.
    fileprivate func filteredAnnotations(_ maxVerticalLevel: Int?, maxVisibleAnnotations: Int?, maxDistance: Double?) -> [ADSBAnnotation]
    {
        let nsAnnotations: NSMutableArray = NSMutableArray(array: annotations)
        
        var filteredAnnotations: [ADSBAnnotation] = []
        var count = 0
        
        let checkMaxVisibleAnnotations = maxVisibleAnnotations != nil
        let checkMaxDistance = maxDistance != nil
        
        for nsAnnotation in nsAnnotations
        {
            let annotation = nsAnnotation as! ADSBAnnotation
            
            // filter by maxVisibleAnnotations
            if(checkMaxVisibleAnnotations && count >= maxVisibleAnnotations!)
            {
                annotation.active = false
                continue
            }
            
            if   (!checkMaxDistance || maxDistance == 0 || annotation.distanceFromUser <= maxDistance!)
            {
                filteredAnnotations.append(annotation)
                annotation.active = true
                count += 1;
            }
            else
            {
                annotation.active = false
            }
        }
        return filteredAnnotations
    }
    
    
    // MARK: -
    // MARK: Events: ARLocationManagerDelegate/Display timer
    
    internal func displayTimerTick()
    {
        let filterFactor: Double = headingSmoothingFactor
        let newHeading = trackingManager.heading
        
        // Picking up the pace if device is being rotated fast or heading of device is at the border(North). It is needed
        // to do this on North border because overlayView changes its position and we don't want it to animate full circle.
        if(headingSmoothingFactor == 1 || fabs(currentHeading - trackingManager.heading) > 50)
        {
            currentHeading = trackingManager.heading
        }
        else
        {
            // Smoothing out heading
            currentHeading = (newHeading * filterFactor) + (currentHeading  * (1.0 - filterFactor))
        }
        
        overlayView.frame = overlayFrame()
        updateAnnotationsForCurrentHeading()
        
        logText("Heading: \(trackingManager.heading)")
    }
    
    internal func arTrackingManager(_ trackingManager: ARTrackingManager, didUpdateUserLocation: CLLocation?)
    {
        if let location = trackingManager.userLocation
        {
            lastLocation = location
        }
        
        // shouldReloadAnnotations will be true if reloadAnnotations was called before location was fetched
        if shouldReloadAnnotations
        {
            reloadAnnotations()
        }
            // Refresh only if we have annotations
        else if activeAnnotations.count > 0
        {
            reload(calculateDistanceAndAzimuth: true, calculateVerticalLevels: true, createAnnotationViews: false)
        }
        
        // Debug view, indicating that update was done
        if(uiOptions.debugEnabled)
        {
            let view = UIView()
            view.frame = CGRect(x: view.bounds.size.width - 80, y: 10, width: 30, height: 30)
            view.backgroundColor = UIColor.red
            view.addSubview(view)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC))
            {
                view.removeFromSuperview()
            }
        }
    }
    
    internal func arTrackingManager(_ trackingManager: ARTrackingManager, didUpdateReloadLocation: CLLocation?)
    {
        // Manual reload?
        if didUpdateReloadLocation != nil && dataSource != nil && dataSource!.responds(to: #selector(ARDataSource.ar(_:shouldReloadWithLocation:)))
        {
            let annotations = dataSource?.ar?(self, shouldReloadWithLocation: didUpdateReloadLocation!)
            if let annotations = annotations
            {
                setAnnotations(annotations);
            }
        }
        else
        {
            reloadAnnotations()
        }
        
        // Debug view, indicating that reload was done
        if(uiOptions.debugEnabled)
        {
            let view = UIView()
            view.frame = CGRect(x: view.bounds.size.width - 80, y: 10, width: 30, height: 30)
            view.backgroundColor = UIColor.blue
            view.addSubview(view)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC))
            {
                view.removeFromSuperview()
            }
        }
    }
    internal func arTrackingManager(_ trackingManager: ARTrackingManager, didFailToFindLocationAfter elapsedSeconds: TimeInterval)
    {
        onDidFailToFindLocation?(elapsedSeconds, lastLocation != nil)
    }
    
    internal func logText(_ text: String)
    {
        debugLabel?.text = text
    }
    
    
    // MARK: -
    // MARK: Camera
    
    fileprivate func loadCamera()
    {
        cameraLayer?.removeFromSuperlayer()
        cameraLayer = nil
        
        //===== Video device/video input
        let captureSessionResult = ARViewController.createCaptureSession()
        guard captureSessionResult.error == nil, let session = captureSessionResult.session else
        {
            print("HDAugmentedReality: Cannot create capture session, use createCaptureSession method to check if device is capable for augmented reality.")
            return
        }
        
        cameraSession = session
        
        //===== View preview layer
        if let cameraLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        {
            cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            view.layer.insertSublayer(cameraLayer, at: 0)
            self.cameraLayer = cameraLayer
        }
    }
    
    /// Tries to find back video device and add video input to it. This method can be used to check if device has hardware available for augmented reality.
    open class func createCaptureSession() -> (session: AVCaptureSession?, error: NSError?)
    {
        var error: NSError?
        var captureSession: AVCaptureSession?
        var backVideoDevice: AVCaptureDevice?
        let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        
        // Get back video device
        if let videoDevices = videoDevices
        {
            for captureDevice in videoDevices
            {
                if (captureDevice as AnyObject).position == AVCaptureDevicePosition.back
                {
                    backVideoDevice = captureDevice as? AVCaptureDevice
                    break
                }
            }
        }
        
        if backVideoDevice != nil
        {
            var videoInput: AVCaptureDeviceInput!
            do {
                videoInput = try AVCaptureDeviceInput(device: backVideoDevice)
            } catch let error1 as NSError {
                error = error1
                videoInput = nil
            }
            if error == nil
            {
                captureSession = AVCaptureSession()
                
                if captureSession!.canAddInput(videoInput)
                {
                    captureSession!.addInput(videoInput)
                }
                else
                {
                    error = NSError(domain: "HDAugmentedReality", code: 10002, userInfo: ["description": "Error adding video input."])
                }
            }
            else
            {
                error = NSError(domain: "HDAugmentedReality", code: 10001, userInfo: ["description": "Error creating capture device input."])
            }
        }
        else
        {
            error = NSError(domain: "HDAugmentedReality", code: 10000, userInfo: ["description": "Back video device not found."])
        }
        
        return (session: captureSession, error: error)
    }
    
    fileprivate func startCamera(notifyLocationFailure: Bool)
    {
        cameraSession.startRunning()
        trackingManager.startTracking(notifyLocationFailure: notifyLocationFailure)
        displayTimer = CADisplayLink(target: self,
                                     selector: #selector(ARViewController.displayTimerTick))
        displayTimer?.add(to: RunLoop.current,
                          forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    fileprivate func stopCamera()
    {
        cameraSession.stopRunning()
        trackingManager.stopTracking()
        displayTimer?.invalidate()
        displayTimer = nil
    }
    
    
    // MARK: -
    // MARK: Overlay
    
    /// Overlay view is used to host annotation views.
    fileprivate func loadOverlay()
    {
        overlayView.removeFromSuperview()
        overlayView = OverlayView()
        view.addSubview(self.overlayView)
    }
    
    fileprivate func overlayFrame() -> CGRect
    {
        let x: CGFloat = view.bounds.size.width / 2 - (CGFloat(currentHeading) * H_PIXELS_PER_DEGREE)
        let y: CGFloat = (CGFloat(self.trackingManager.pitch) * (180.0 / .pi) * H_PIXELS_PER_DEGREE) - self.view.bounds.size.height / 2
        let newFrame = CGRect(x: x, y: y, width: OVERLAY_VIEW_WIDTH, height: view.bounds.size.height)
        return newFrame
    }
    
    fileprivate func layoutUi()
    {
        cameraLayer?.frame = self.view.bounds
        overlayView.frame = self.overlayFrame()
        overlayView.layer.frame = overlayView.bounds
//        overlayView.layer.borderWidth = 3
//        overlayView.layer.borderColor = UIColor.red.cgColor
        closeButton?.frame = CGRect(x: self.view.bounds.size.width - 53, y: self.view.bounds.size.height - 103,width: 44,height: 44)
    }
    
    
    // MARK: -
    // MARK: Rotation/Orientation
    
    open override var shouldAutorotate : Bool
    {
        return true
    }
    
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask(rawValue: self.interfaceOrientationMask.rawValue)
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition:
        {
            (coordinatorContext) in
            
            self.setOrientation(UIApplication.shared.statusBarOrientation)
        })
        {
            [unowned self] (coordinatorContext) in
            
            self.layoutAndReloadOnOrientationChange()
        }
    }
    
    internal func layoutAndReloadOnOrientationChange()
    {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        layoutUi()
        reload(calculateDistanceAndAzimuth: false, calculateVerticalLevels: false, createAnnotationViews: false)
        
        CATransaction.commit()
    }
    
    fileprivate func setOrientation(_ orientation: UIInterfaceOrientation)
    {
        if self.cameraLayer?.connection?.isVideoOrientationSupported != nil
        {
            if let videoOrientation = AVCaptureVideoOrientation(rawValue: Int(orientation.rawValue))
            {
                self.cameraLayer?.connection?.videoOrientation = videoOrientation
            }
        }
        
        if let deviceOrientation = CLDeviceOrientation(rawValue: Int32(orientation.rawValue))
        {
            self.trackingManager.orientation = deviceOrientation
        }
    }

    
    // MARK: -
    // MARK: UI
   
    func addCloseButton()
    {
        self.closeButton?.removeFromSuperview()
        
        self.closeButtonImage = #imageLiteral(resourceName: "RadarButtonIcon")
        self.closeButton?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Close button - make it customizable
        let closeButton: UIButton = UIButton(type: UIButtonType.custom)
        closeButton.setImage(closeButtonImage, for: UIControlState());
        closeButton.frame = CGRect(x: self.view.bounds.size.width - 53, y: self.view.bounds.size.height - 103,width: 44,height: 44)
        closeButton.addTarget(self, action: #selector(ARViewController.closeButtonTap), for: UIControlEvents.touchUpInside)
        closeButton.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.view.addSubview(closeButton)
        self.closeButton = closeButton
    }
   

    
    
    // MARK: -
    // MARK: OverlayView class
    
    /// Normal UIView that registers taps on subviews out of its bounds.
    fileprivate class OverlayView: UIView
    {
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?
        {
            if(!self.clipsToBounds && !self.isHidden)
            {
                for subview in self.subviews.reversed()
                {
                    let subPoint = subview.convert(point, from: self)
                    if let result:UIView = subview.hitTest(subPoint, with:event)
                    {
                        return result;
                    }
                }
            }
            return nil
        }
    }
    
    // MARK: -
    // MARK: UiOptions
    public struct UiOptions
    {
        /// Enables/Disables debug UI, like heading label, map button, some views when updating/reloading.
        public var debugEnabled = true
        /// Enables/Disables close button.
        public var closeButtonEnabled = true
    }
    
   
}

//MARK: -
//MARK: Annotation update
extension ARViewController {
    @objc func aircraftListHasBeenUpdated(){
        let aircraftList = ADSBCacheManager.sharedInstance.adsbAircrafts
        for aircraft in aircraftList {
            if (aircraft.isOnGround ?? false)  && ADSBConfig.isGroundAircraftFilterOn { continue }
            let annotationId = kAircraftAnnotationId + (aircraft.icaoId ?? "") + (aircraft.registration ?? "")
            if aircraft.latitude == nil || aircraft.longitude == nil { continue }
            let latitude = CLLocationDegrees(aircraft.latitude!)
            let longitude = CLLocationDegrees(aircraft.longitude!)
            let coordination = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let altitude = CLLocationDistance(aircraft.presAltitude ?? 0)
            let speed = CLLocationSpeed(aircraft.groundSpeed ?? 0)
            let heading = CLLocationDirection(aircraft.trackHeading ?? 0)
            updateAnnotation(annotationId,
                             withLocation: CLLocation(coordinate: coordination,
                                                      altitude: altitude,
                                                      horizontalAccuracy: CLLocationAccuracy(10),
                                                      verticalAccuracy:  CLLocationAccuracy(10),
                                                      course: heading,
                                                      speed: speed,
                                                      timestamp: Date()),
                             aircraft: aircraft)
            
        }
        cleareExpiredAnnotation()
        reload(calculateDistanceAndAzimuth: true, calculateVerticalLevels: true, createAnnotationViews: true)
    }
    
    
    func updateAnnotation(_ identifier: String, withLocation location: CLLocation, aircraft: ADSBAircraft?){
        
        for annotation in self.annotations{
            if annotation.identifier == identifier {
                annotation.coordinate = location.coordinate
                annotation.location = location
                annotation.aircraft = aircraft
                return
            }
        }
        let newAnnotation = createAnnotation(identifier, location: location, aircraft: aircraft)
        annotations.append(newAnnotation)
    }
    
    func createAnnotation(_ identifier: String, location: CLLocation, aircraft: ADSBAircraft?) -> ADSBAnnotation {
        let annotation = ADSBAnnotation()
        annotation.title = String("\(aircraft?.callsign ?? "---")")
        annotation.identifier = identifier
        annotation.subtitle = identifier
        annotation.coordinate = location.coordinate
        annotation.location = location
        annotation.aircraft = aircraft
        return annotation
    }
    
    func cleareExpiredAnnotation(){
        var i = 0
        for anAnnotation in annotations {
            let secondsInterval = Date().timeIntervalSince((anAnnotation.location?.timestamp)!)
            if secondsInterval > ADSBConfig.expireSeconds {
                annotations.remove(at: i)
                i = i - 1
            } else if secondsInterval > 1 {
                guard anAnnotation.annotationView != nil else {
                    continue
                }
               anAnnotation.annotationView?.alpha = (anAnnotation.annotationView?.alpha)! * 0.5
            }
            i = i + 1
        }
        
    }
    
    func removeOnGroundAircraftAnnotation() {
        var i = 0
        for anAnnotation in annotations {
            if anAnnotation.aircraft?.isOnGround ?? false{
                annotations.remove(at: i)
            }
            i = i + 1
        }
    }
}

















