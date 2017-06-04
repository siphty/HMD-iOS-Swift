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
    
    @IBOutlet weak var fpvView : UIView!
    @IBOutlet weak var fpvTemView : UIView!
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
//        let hmdWidth = view.bounds.height - 60
//        let hmdHeight = hmdWidth
//        hmdLayer.frame = CGRect(x: (view.bounds.width - hmdWidth) / 2,
//                                y: 30,
//                                width: hmdWidth,
//                                height: hmdHeight)
//        hmdLayer.borderWidth = 1
//        hmdLayer.borderColor = UIColor.yellow.cgColor
//        view.layer.addSublayer(hmdLayer)
        view.bringSubview(toFront: returnButton)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let camera: DJICamera? = fetchCamera()
        if camera != nil {
            camera!.delegate = self
        }
        VideoPreviewer.instance().enableHardwareDecode = false
        VideoPreviewer.instance().setEnableBinocular(false)
        VideoPreviewer.instance().setView(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        VideoPreviewer.instance().close()
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
    
   


}



extension PilotHUDViewController: DJICameraDelegate{
    func camera(_ camera: DJICamera, didReceiveVideoData videoBuffer: UnsafeMutablePointer<UInt8>, length size: Int){
        VideoPreviewer.instance().push(videoBuffer, length: Int32(size))
    }
    
//    func camera(_ camera: DJICamera, didUpdate cameraState: DJICameraSystemState) {
//        self.isRecording = cameraState.isRecording
////        self.recordTimeLabel.isHidden = !self.isRecording
////        
////        self.recordTimeLabel.text = formatSeconds(seconds: cameraState.currentVideoRecordingTimeInSeconds)
//        
//        if (self.isRecording == true) {
////            self.recordButton.setTitle("Stop Record", for: UIControlState.normal)
//        } else {
////            self.recordButton.setTitle("Start Record", for: UIControlState.normal)
//        }
//        
//        //Update UISegmented Control's State
//        if (cameraState.mode == DJICameraMode.shootPhoto) {
////            self.workModeSegmentControl.selectedSegmentIndex = 0
//        } else {
////            self.workModeSegmentControl.selectedSegmentIndex = 1
//        }
//        
//    }
    
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
