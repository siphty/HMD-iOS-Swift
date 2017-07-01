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
import CoreMotion

class PilotHUDViewController: UIViewController {
    var isRecording : Bool!
    var hmdLayer = HMDLayer()
    var isSettingMode:Bool = false
    var previewerAdapter = VideoPreviewerSDKAdapter()
    let motionManager = CMMotionManager()
    var orientationAttitude: CMAttitude?
    var inverseReferenceQuaternion: CMQuaternion?
    
    let radiansToDegrees: (Double) -> Double = {
        return $0 * (180.0 / Double.pi)
    }
//    @IBOutlet weak var fpvView : UIView!
//    @IBOutlet weak var fpvTemView : UIView!
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
    override func viewDidAppear(_ animated: Bool) {
//        let queue = OperationQueue()
//        motionManager.startDeviceMotionUpdates(to: queue) { (data: CMDeviceMotion?, error: Error?) in
//            guard data != nil else { return }
//            guard let attitude = data?.attitude else { return }
//            self.setGimbal(with: attitude)
//        }
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
        
//        motionManager.startAccelerometerUpdates()
//        motionManager.startGyroUpdates()
//        motionManager.startMagnetometerUpdates()
//        coreMotionTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(setGimbal), userInfo: nil, repeats: true)
        let queue = OperationQueue()
        motionManager.startDeviceMotionUpdates(using: CMAttitudeReferenceFrame.xArbitraryZVertical,
                                               to: queue) { (data: CMDeviceMotion?, error: Error?) in
                                                guard data != nil else { return }
                                                guard let attitude = data?.attitude else { return }
                                                self.setGimbal(with: attitude)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        VideoPreviewer.instance().close()
        VideoPreviewer.instance().unSetView()
        VideoPreviewer.instance().clearRender()
        VideoPreviewer.instance().clearVideoData()
        previewerAdapter.stop()
        
        
//        motionManager.stopAccelerometerUpdates()
//        motionManager.stopGyroUpdates()
//        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
//        coreMotionTimer.invalidate()
//        coreMotionTimer = nil
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
    
    func setGimbal(with iOSDeviceAttitude: CMAttitude) {
        if orientationAttitude == nil { resetOrientation() }
//        attitude.multiply(byInverseOf: orientationAttitude!)
//        let currentQuaternion = attitude.quaternion
//        print(attitude)
//        attitude.multiply(byInverseOf: orientationAttitude!)
        var djiAttitude = DJIAttitude()
        var pitch = radiansToDegrees(iOSDeviceAttitude.roll) - 90
        djiAttitude.pitch = pitch
        
        var yaw = radiansToDegrees(iOSDeviceAttitude.yaw) - radiansToDegrees((orientationAttitude?.yaw)!)
        djiAttitude.yaw = yaw
        
        var roll = radiansToDegrees(iOSDeviceAttitude.pitch)
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
        print("pitch: \(attitude.pitch)     yaw: \(attitude.yaw)    roll: \(attitude.roll)")
        guard let gimbal = DJISDKManager.product()?.gimbal else { return }
        
        if gimbal.isFeatureSupported(by: DJIGimbalParamAdjustPitch) {
            guard let pitchRotationMax = gimbal.getParamMax(by: DJIGimbalParamAdjustPitch) else { return }
            guard let pitchRotationMin = gimbal.getParamMin(by: DJIGimbalParamAdjustPitch) else { return }
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
        
        if gimbal.isFeatureSupported(by: DJIGimbalParamAdjustYaw) {
            guard let yawRotationMax = gimbal.getParamMax(by: DJIGimbalParamAdjustYaw) else { return }
            guard let yawRotationMin = gimbal.getParamMin(by: DJIGimbalParamAdjustYaw) else {return}
            yawRotation = NSNumber(value: attitude.yaw)
//            let rangeYaw = yawRotationMax.doubleValue - yawRotationMin.doubleValue
            if yawRotation.doubleValue > yawRotationMax.doubleValue {
                yawRotation = yawRotationMax
            }
            if yawRotation.doubleValue > yawRotationMin.doubleValue {
                yawRotation = yawRotationMin
            }
        }
        
        if gimbal.isFeatureSupported(by: DJIGimbalParamAdjustRoll) {
            guard let rollRotationMax = gimbal.getParamMax(by: DJIGimbalParamAdjustRoll) else { return }
            guard let rollRotationMin = gimbal.getParamMin(by: DJIGimbalParamAdjustRoll) else {return}
            rollRotation = NSNumber(value: attitude.roll)
//            let rangeroll = rollRotationMax.doubleValue - rollRotationMin.doubleValue
            if rollRotation.doubleValue > rollRotationMax.doubleValue {
                rollRotation = rollRotationMax
            }
            if rollRotation.doubleValue < rollRotationMin.doubleValue {
                rollRotation = rollRotationMin
            }
        }
        
        let rotation = DJIGimbalRotation(pitchValue: pitchRotation, rollValue: rollRotation, yawValue: yawRotation, time: 0, mode: DJIGimbalRotationMode.absoluteAngle)
        gimbal.rotate(with: rotation) { (error: Error?) in
            if error != nil {
                print("Error: \(error)")
            }
            
        }
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
