//
//  PilotHUDViewController.swift
//  HMD
//
//  Created by Yi JIANG on 29/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion
import DJISDK
import VideoPreviewer

class PilotHUDViewController: UIViewController {
    var isRecording : Bool!
    var hmdLayer = HMDLayer()
    var isSettingMode:Bool = false
    var previewerAdapter = VideoPreviewerSDKAdapter()
    let motionManager = CMMotionManager()
    var coreMotionTimer: Timer!
    var orientationAttitude: CMAttitude?
    var inverseReferenceQuaternion: CMQuaternion?
    var gimbalSettingLock: Bool = false
    var gimbal: DJIGimbal?
    var rollRotationMax: NSNumber = 0.0
    var rollRotationMin: NSNumber = 0.0
    var pitchRotationMax: NSNumber = 0.0
    var pitchRotationMin: NSNumber = 0.0
    var yawRotationMax: NSNumber = 0.0
    var yawRotationMin: NSNumber = 0.0
    var isRollControllable: Bool = false
    var isPitchControllable: Bool = false
    var isYawControllable: Bool = false
    
    let radiansToDegrees: (Double) -> Double = {
        return $0 * (180.0 / Double.pi)
    }
    
        
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
        let hmdWidth = view.bounds.height - 10
        let hmdHeight = hmdWidth
        hmdLayer.frame = CGRect(x: (view.bounds.width - hmdWidth) / 2,
                                y: 5,
                                width: hmdWidth,
                                height: hmdHeight)
        view.layer.addSublayer(hmdLayer)
        view.bringSubview(toFront: returnButton)
        
        
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
        
        for _ in 0 ... 10 {
            if initialGimbal() {
                sleep(1)
                break
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        VideoPreviewer.instance().close()
        VideoPreviewer.instance().unSetView()
        VideoPreviewer.instance().clearRender()
        VideoPreviewer.instance().clearVideoData()
        previewerAdapter.stop()
        
        motionManager.stopDeviceMotionUpdates()
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
    

    
}

extension PilotHUDViewController: DJICameraDelegate{
    func camera(_ camera: DJICamera, didReceiveVideoData videoBuffer: UnsafeMutablePointer<UInt8>, length size: Int){
        VideoPreviewer.instance().push(videoBuffer, length: Int32(size))
    }
    
    func camera(_ camera: DJICamera, didUpdate systemState: DJICameraSystemState) {
        if systemState.mode == DJICameraMode.playback || systemState.mode == DJICameraMode.mediaDownload {
            if !self.isSettingMode {
                self.isSettingMode = true
                camera.setMode(DJICameraMode.shootPhoto, withCompletion: {[weak self](error: Error?) -> Void in
                    if error == nil {
                        self?.isSettingMode = false
                    }
                })
            }
        }
    }
}

extension PilotHUDViewController {
    func initialGimbal() -> Bool {
        guard DJISDKManager.product()?.gimbal != nil else {
            return false
        }
        gimbal = DJISDKManager.product()?.gimbal
        gimbal?.setPitchRangeExtensionEnabled(true, withCompletion: nil)
        gimbal?.getMovementSettingsProfile(completion: { (settingProfile: DJIGimbalMovementSettingsProfile, error: Error?) in
            if error != nil {
                print("error: \(String(describing: error)))")
            }
            print("Setting Profile: \(settingProfile)")
        })
        
        isPitchControllable = (gimbal?.isFeatureSupported(by: DJIGimbalParamAdjustPitch))!
        isRollControllable = (gimbal?.isFeatureSupported(by: DJIGimbalParamAdjustRoll))!
        isYawControllable = (gimbal?.isFeatureSupported(by: DJIGimbalParamAdjustYaw))!
        if isYawControllable {
            gimbal?.setControllerSpeedCoefficient(100, on: DJIGimbalAxis.yaw , withCompletion: nil)
            gimbal?.setControllerSmoothingFactor(1, on: DJIGimbalAxis.yaw, withCompletion: nil)
            gimbal?.setSmoothTrackAcceleration(1, on:  DJIGimbalAxis.yaw, withCompletion: nil)
        }
        if isPitchControllable {
            gimbal?.setControllerSpeedCoefficient(100, on: DJIGimbalAxis.pitch , withCompletion: nil)
            gimbal?.setControllerSmoothingFactor(1, on: DJIGimbalAxis.pitch, withCompletion: nil)
            gimbal?.setSmoothTrackAcceleration(1, on:  DJIGimbalAxis.pitch, withCompletion: nil)
        }
        if isRollControllable {
            gimbal?.setControllerSpeedCoefficient(100, on: DJIGimbalAxis.roll , withCompletion: nil)
            gimbal?.setControllerSmoothingFactor(1, on: DJIGimbalAxis.roll, withCompletion: nil)
        }
        rollRotationMax = gimbal?.getParamMax(by: DJIGimbalParamAdjustRoll) ?? 0.0
        rollRotationMin = gimbal?.getParamMin(by: DJIGimbalParamAdjustRoll) ?? 0.0
        pitchRotationMax = gimbal?.getParamMax(by: DJIGimbalParamAdjustPitch) ?? 0.0
        pitchRotationMin = gimbal?.getParamMin(by: DJIGimbalParamAdjustPitch) ?? 0.0
        yawRotationMax = gimbal?.getParamMax(by: DJIGimbalParamAdjustYaw) ?? 0.0
        yawRotationMin = gimbal?.getParamMin(by: DJIGimbalParamAdjustYaw) ?? 0.0
        
        let queue = OperationQueue()
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical,
                                               to: queue) { (data: CMDeviceMotion?, error: Error?) in
                                                guard data != nil else { return }
                                                guard let attitude = data?.attitude else { return }
                                                self.setGimbal(with: attitude)
        }
        
        return true
    }

    
    func setGimbal(with iOSDeviceAttitude: CMAttitude) {
        if orientationAttitude == nil { resetOrientation() }
        if gimbalSettingLock == true { return }
        var djiAttitude = DJIAttitude()
        let pitch = radiansToDegrees(iOSDeviceAttitude.roll) - 90
        djiAttitude.pitch = pitch
        
        let yaw = radiansToDegrees(iOSDeviceAttitude.yaw) - radiansToDegrees((orientationAttitude?.yaw)!)
        djiAttitude.yaw = yaw
        
        let roll = radiansToDegrees(iOSDeviceAttitude.pitch)
        djiAttitude.roll = roll
        
        setGimbal(by: djiAttitude )
    }
    
    func resetOrientation() {
        guard let initialAttitude = motionManager.deviceMotion?.attitude else { return }
        orientationAttitude = initialAttitude
    }
    
    func setGimbal(by attitude: DJIAttitude) {
        var pitchRotation: NSNumber = 0.0
        var yawRotation: NSNumber = 0.0
        var rollRotation: NSNumber = 0.0
        //        print("pitch: \(attitude.pitch)     yaw: \(attitude.yaw)    roll: \(attitude.roll)")
        guard gimbal != nil else { return }
        if isPitchControllable {
            pitchRotation = NSNumber(value: attitude.pitch)
            //            let rangepitch = CGFloat(pitchRotationMax) - CGFloat(pitchRotationMin)
            if pitchRotation.doubleValue > pitchRotationMax.doubleValue  {
                pitchRotation = pitchRotationMax
            }
            if pitchRotation.doubleValue < pitchRotationMin.doubleValue {
                pitchRotation = pitchRotationMin
            }
            
            //            print("range of pitch: \(rangepitch)    pitch Rotation: \(pitchRotation)")
            
        }
        
        if (gimbal?.isFeatureSupported(by: DJIGimbalParamAdjustYaw))! {
            yawRotation = NSNumber(value: attitude.yaw * -1)
            //            let rangeYaw = yawRotationMax.doubleValue - yawRotationMin.doubleValue
            if yawRotation.doubleValue > yawRotationMax.doubleValue {
                yawRotation = yawRotationMax
            }
            if yawRotation.doubleValue < yawRotationMin.doubleValue {
                yawRotation = yawRotationMin
            }
        }
        
        if (gimbal?.isFeatureSupported(by: DJIGimbalParamAdjustRoll))! {
            rollRotation = NSNumber(value: attitude.roll)
            //            let rangeroll = rollRotationMax.doubleValue - rollRotationMin.doubleValue
            if rollRotation.doubleValue > rollRotationMax.doubleValue {
                rollRotation = rollRotationMax
            }
            if rollRotation.doubleValue < rollRotationMin.doubleValue {
                rollRotation = rollRotationMin
            }
        }
        print("Going to set: pitch:\(pitchRotation) ; roll:\(rollRotation) ; yaw:\(yawRotation)")
        let rotation = DJIGimbalRotation(pitchValue: pitchRotation, rollValue: rollRotation, yawValue: yawRotation, time: 0.001, mode: DJIGimbalRotationMode.absoluteAngle)
        gimbalSettingLock = true
        gimbal?.rotate(with: rotation) { (error: Error?) in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
            self.gimbalSettingLock = false
            
        }
    }
    
}
