//
//  DroneCockpitViewController.swift
//  HMD
//
//  Created by Yi JIANG on 4/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import DJISDK
import VideoPreviewer
import DJIUILibrary

class DroneCockpitViewController: UIViewController {
    var isRecording : Bool!
    var hmdLayer = HMDLayer()
    var isSettingMode:Bool = false
    var previewerAdapter            = VideoPreviewerSDKAdapter()
    
    let statusBarViewController     = DULStatusBarViewController()
    let dockViewController          = DULDockViewController()
    let sideBarViewController       = DULSideBarViewController()
    let leadingBarViewController    = DULLeadingBarViewController()
    let trailingBarViewController   = DULTrailingBarViewController()
    
//    var preflightChecklistController = DUL
   
    @IBOutlet weak var statusBarContainingView: UIView!
    @IBOutlet weak var dockContainingView: UIView!
    @IBOutlet weak var trailingBarContainingView: UIView!
    @IBOutlet weak var leadingBarContainingView: UIView!
    
    @IBOutlet weak var returnButton: UIButton!
    @IBAction func close () {
        self.dismiss(animated: true) {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VideoPreviewer.instance().start()
        previewerAdapter = VideoPreviewerSDKAdapter.withDefaultSettings()
        previewerAdapter.start()
        view.bringSubview(toFront: returnButton)
        initialCockpitViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let camera: DJICamera? = fetchCamera()
        if camera != nil {
            camera!.delegate = self
        }
        previewerAdapter.start()
        VideoPreviewer.instance().start()
        VideoPreviewer.instance().enableHardwareDecode = false
        VideoPreviewer.instance().setEnableBinocular(false)
        VideoPreviewer.instance().setView(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        VideoPreviewer.instance().close()
        VideoPreviewer.instance().unSetView()
        VideoPreviewer.instance().clearRender()
        VideoPreviewer.instance().clearVideoData()
        previewerAdapter.stop()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        VideoPreviewer.instance().close()
        VideoPreviewer.instance().unSetView()
        VideoPreviewer.instance().clearRender()
        VideoPreviewer.instance().clearVideoData()
        hmdLayer.unSetup()
    }
    
    func fetchCamera() -> DJICamera? {
        let product = DJISDKManager.product()
        if  product is DJIAircraft || product is DJIHandheld{
            return product?.camera
        }
        return nil
    }
    
    func formatSeconds(seconds: UInt) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        return(dateFormatter.string(from: date))
    }
    
    func initialCockpitViewControllers(){
        // Status Top Bar
        statusBarViewController.widget(with: DULPreFlightStatusWidget.self)
        addChildViewController(statusBarViewController)
        statusBarContainingView.addSubview(statusBarViewController.view)
        statusBarViewController.view.translatesAutoresizingMaskIntoConstraints = false;
        statusBarViewController.view.topAnchor.constraint(equalTo:statusBarContainingView.topAnchor).isActive = true
        statusBarViewController.view.bottomAnchor.constraint(equalTo:statusBarContainingView.bottomAnchor).isActive = true
        statusBarViewController.view.leadingAnchor.constraint(equalTo:statusBarContainingView.leadingAnchor).isActive = true
        statusBarViewController.view.trailingAnchor.constraint(equalTo:statusBarContainingView.trailingAnchor).isActive = true
        
        guard let djiLogoWidget = self.statusBarViewController.widget(at: 0) else {
            return
        }
        self.statusBarViewController.removeWidget(djiLogoWidget)
        
        guard let djiPreflightStatusWidget: DULWidget = statusBarViewController.widget(with: DULPreFlightStatusWidget.self) as? DULWidget else {
            return
        }
        djiPreflightStatusWidget.action =  {
           self.preflightStatusWidgetTouchUpInside()
        }
        
        // Trailing Bar View
        for childViewController in childViewControllers {
            if childViewController is DULTrailingBarViewController {
                let trailingBarViewController = childViewController as! DULTrailingBarViewController
                guard let djiExposureSettignsWidget = trailingBarViewController.widget(with: DULExposureSettingsMenu.self) as? DULExposureSettingsMenu else{
                    return
                }
                djiExposureSettignsWidget.action = {
                    self.exposureSettingsWidgetTouchUpInside()
                }
            }
        }
        
        // Dock View
        addChildViewController(dockViewController)
        dockContainingView.addSubview(dockViewController.view)
        dockViewController.view.translatesAutoresizingMaskIntoConstraints = false;
        dockViewController.view.topAnchor.constraint(equalTo: dockContainingView.topAnchor).isActive = true
        dockViewController.view.bottomAnchor.constraint(equalTo: dockContainingView.bottomAnchor).isActive = true
        dockViewController.view.leadingAnchor.constraint(equalTo: dockContainingView.leadingAnchor).isActive = true
        dockViewController.view.trailingAnchor.constraint(equalTo: dockContainingView.trailingAnchor).isActive = true
        guard let djiDushboardWidget = dockViewController.widget(with: DULDashboardWidget.self) as? DULDashboardWidget else {
            return
        }
        for subview in djiDushboardWidget.subviews{
            if subview is DULCompassWidget {
                guard let djiCompassWidget = subview as? DULCompassWidget else{
                    return
                }
                djiCompassWidget.action = {
                    self.compassWidgetTouchUpInside()
                }
                
            }
        }
//        guard let djiCompassWidget = djiDushboardWidget.widget(with: DULCompassWidget.self) as? DULCompassWidget else {
//            return
//        }
//        djiCompassWidget.action = {
//            self.compassWidgetTouchUpInside()
//        }
        
    }
    
    func preflightStatusWidgetTouchUpInside(){
        //TODO: Show preflight view controller
        print("📮preflightStatus been touched")
    }
    
    func compassWidgetTouchUpInside(){
        print("🖇Compass been touched")
    }
    
    func exposureSettingsWidgetTouchUpInside(){
        print("📌 exposureSettings  been touched")
    }
}


extension DroneCockpitViewController: DJICameraDelegate{
    func camera(_ camera: DJICamera, didReceiveVideoData videoBuffer: UnsafeMutablePointer<UInt8>, length size: Int){
        VideoPreviewer.instance().push(videoBuffer, length: Int32(size))
    }
    
    
    func camera(_ camera: DJICamera, didUpdate systemState: DJICameraSystemState) {
        if systemState.mode == DJICameraMode.playback || systemState.mode == DJICameraMode.mediaDownload {
            if !isSettingMode {
                isSettingMode = true
                camera.setMode(DJICameraMode.shootPhoto, withCompletion: {[weak self](error: Error?) -> Void in
                    if error == nil {
                        self?.isSettingMode = false
                    }
                })
            }
        }
    }
}
