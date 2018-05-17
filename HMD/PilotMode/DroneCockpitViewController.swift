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
import DJIUXSDK

class DroneCockpitViewController: UIViewController {
    var isRecording : Bool!
    var hmdLayer = HMDLayer()
    var isSettingMode = false
    var previewerAdapter            = VideoPreviewerSDKAdapter()
    
    let statusBarViewController     = DUXStatusBarViewController()
    let dockViewController          = DUXDockViewController()
    let sideBarViewController       = DUXSideBarViewController()
    let leadingBarViewController    = DUXLeadingBarViewController()
    let trailingBarViewController   = DUXTrailingBarViewController()
    let preflightCheckViewController = DUXPreflightChecklistController()
    let cameraMenuViewController    = DUXCameraSettingsController()
    let mapThumbnailView            = MKMapView()
    var AeroChartVC                 = DroneAeroChartViewController()
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
        AeroChartVC = storyboard?.instantiateViewController(withIdentifier: "AeroChartVC") as! DroneAeroChartViewController
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
        statusBarViewController.widget(with: DUXPreFlightStatusWidget.self)
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
        
        guard let djiPreflightStatusWidget: DUXWidget = statusBarViewController.widget(with: DUXPreFlightStatusWidget.self) as? DUXWidget else {
            return
        }
        djiPreflightStatusWidget.action =  {
           self.preflightStatusWidgetTouchUpInside()
        }
        
        // Trailing Bar View
        for childViewController in childViewControllers {
            if childViewController is DUXTrailingBarViewController {
                let trailingBarViewController = childViewController as! DUXTrailingBarViewController
                guard let djiExposureSettignsWidget = trailingBarViewController.widget(with: DUXExposureSettingsMenu.self) as? DUXExposureSettingsMenu else{
                    return
                }
                djiExposureSettignsWidget.action = {
                    self.exposureSettingsWidgetTouchUpInside()
                }
                guard let djiCameraSettingsWidget = trailingBarViewController.widget(with: DUXCameraSettingsMenu.self) as? DUXCameraSettingsMenu else{
                    return
                }
                djiCameraSettingsWidget.action = {
                    self.cameraSettingsManuWidgetTouchUpInside()
                }
            } 
        }
        
        // Dock View
        addChildViewController(dockViewController)
        dockContainingView.addSubview(dockViewController.view)
        dockViewController.view.translatesAutoresizingMaskIntoConstraints = false
        dockViewController.view.topAnchor.constraint(equalTo: dockContainingView.topAnchor).isActive = true
        dockViewController.view.bottomAnchor.constraint(equalTo: dockContainingView.bottomAnchor).isActive = true
        dockViewController.view.leadingAnchor.constraint(equalTo: dockContainingView.leadingAnchor).isActive = true
        dockViewController.view.trailingAnchor.constraint(equalTo: dockContainingView.trailingAnchor).isActive = true
        guard let djiDushboardWidget = dockViewController.widget(with: DUXDashboardWidget.self) as? DUXDashboardWidget else {
            return
        }
        for subview in djiDushboardWidget.subviews{
            if subview is DUXCompassWidget {
                guard let djiCompassWidget = subview as? DUXCompassWidget else{
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
        let checklistVC = storyboard?.instantiateViewController(withIdentifier: "PreflightChecklistVC") as! DUXPreflightChecklistController
        self.popoverChildViewController(checklistVC)
        checklistVC.view.translatesAutoresizingMaskIntoConstraints = false
        checklistVC.view.topAnchor.constraint(equalTo: statusBarContainingView.bottomAnchor).isActive = true
        checklistVC.view.leftAnchor.constraint(equalTo: statusBarContainingView.leftAnchor).isActive = true
        checklistVC.view.rightAnchor.constraint(equalTo: trailingBarContainingView.leftAnchor, constant: -4).isActive = true
        checklistVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        for subview in checklistVC.view.subviews {
            if subview is UIButton {
                print("I found the button!")
                let dismissButton = subview as! UIButton
                let newDismissButton = UIButton()
                newDismissButton.add(for: .touchUpInside) {
                    self.dismissPopoverChildViewController(checklistVC)
                    
                }
                newDismissButton.setImage(#imageLiteral(resourceName: "UICancelIcon"), for: .normal)
                checklistVC.view.addSubview(newDismissButton)
                checklistVC.view.bringSubview(toFront: newDismissButton)
                newDismissButton.bounds.size = CGSize(width: 44, height: 44)
                newDismissButton.translatesAutoresizingMaskIntoConstraints = false
                newDismissButton.rightAnchor.constraint(equalTo: checklistVC.view.rightAnchor, constant: -4).isActive = true
                newDismissButton.topAnchor.constraint(equalTo: checklistVC.view.topAnchor, constant: 4).isActive = true
                dismissButton.removeFromSuperview()
            } else if subview is UILabel {
                let titleLabel = subview as! UILabel
                if titleLabel.text == "Checklist" {
                    titleLabel.text = "Preflight Checklist"
                    titleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    titleLabel.font =  UIFont(name: "Gotham-Light", size: 13)
                }
            }
        }
    }
    
    func compassWidgetTouchUpInside(){
        self.displayChildViewController(AeroChartVC)
        AeroChartVC.mapView.isFullScreen = false
        AeroChartVC.view.translatesAutoresizingMaskIntoConstraints = false
        AeroChartVC.view.topAnchor.constraint(equalTo: dockContainingView.topAnchor).isActive = true
        AeroChartVC.view.leftAnchor.constraint(equalTo: dockContainingView.leftAnchor, constant: -18).isActive = true
        AeroChartVC.view.rightAnchor.constraint(equalTo: dockContainingView.leftAnchor, constant: 108).isActive = true
        AeroChartVC.view.bottomAnchor.constraint(equalTo: dockContainingView.bottomAnchor).isActive = true
    }
    
    func exposureSettingsWidgetTouchUpInside(){
        let exposureSettingsVC = storyboard?.instantiateViewController(withIdentifier: "CameraExposureSettingsVC") as! DUXExposureSettingsController
        self.popoverChildViewController(exposureSettingsVC)
        exposureSettingsVC.view.translatesAutoresizingMaskIntoConstraints = false
        exposureSettingsVC.view.topAnchor.constraint(equalTo: statusBarContainingView.bottomAnchor, constant: 4).isActive = true
        exposureSettingsVC.view.rightAnchor.constraint(equalTo: trailingBarContainingView.leftAnchor, constant: 2).isActive = true
        exposureSettingsVC.view.leftAnchor.constraint(equalTo: trailingBarContainingView.leftAnchor, constant: -250).isActive = true
        exposureSettingsVC.view.bottomAnchor.constraint(equalTo: dockContainingView.topAnchor, constant: 55).isActive = true
    }


    func cameraSettingsManuWidgetTouchUpInside() {
        let cameraManuVC = storyboard?.instantiateViewController(withIdentifier: "CameraSettingsViewController") as! DUXCameraSettingsController
        self.popoverChildViewController(cameraManuVC)
        cameraManuVC.view.translatesAutoresizingMaskIntoConstraints = false
        cameraManuVC.view.topAnchor.constraint(equalTo: statusBarContainingView.bottomAnchor, constant: 4).isActive = true
        cameraManuVC.view.rightAnchor.constraint(equalTo: trailingBarContainingView.leftAnchor, constant: 2).isActive = true
        cameraManuVC.view.leftAnchor.constraint(equalTo: trailingBarContainingView.leftAnchor, constant: -250).isActive = true
        cameraManuVC.view.bottomAnchor.constraint(equalTo: dockContainingView.topAnchor, constant: 55).isActive = true
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "segueToFullAeroChart" {
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFullAeroChart" {
            let aeroChartViewController = segue.destination as! DroneAeroChartViewController
            let dismissButton = UIButton()
            dismissButton.setImage(#imageLiteral(resourceName: "UICancelIconB"), for: .normal)
            dismissButton.backgroundColor = UIColor.clear
            dismissButton.frame = CGRect(x: 10, y: 10, width: 44, height: 44)
            dismissButton.add(for: .touchUpInside, {
                aeroChartViewController.dismiss(animated: true)
            })
            aeroChartViewController.view.addSubview(dismissButton)
        }
    }
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if unwindSegue.identifier == "segueToFullAeroChart" {
            
        }
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


