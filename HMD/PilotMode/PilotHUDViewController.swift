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
    
    @IBOutlet weak var returnButton: UIButton!
    
    @IBAction func close () {
        self.dismiss(animated: true) {
            self.resetVideoPreview()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupVideoPreviewer()
        
        let hmdWidth = view.bounds.height - 60
        let hmdHeight = hmdWidth
        hmdLayer.frame = CGRect(x: (view.bounds.width - hmdWidth) / 2,
                                y: 30,
                                width: hmdWidth,
                                height: hmdHeight)
        hmdLayer.borderWidth = 1
        hmdLayer.borderColor = UIColor.yellow.cgColor
        view.layer.addSublayer(hmdLayer)
        view.bringSubview(toFront: returnButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.resetVideoPreview()
    }
    

    func setupVideoPreviewer() {
        
        VideoPreviewer.instance().setView(self.view)
        let product = DJISDKManager.product();
        
        //Use "SecondaryVideoFeed" if the DJI Product is A3, N3, Matrice 600, or Matrice 600 Pro, otherwise, use "primaryVideoFeed".
        if ((product?.model == DJIAircraftModelNameA3)
            || (product?.model == DJIAircraftModelNameN3)
            || (product?.model == DJIAircraftModelNameMatrice600)
            || (product?.model == DJIAircraftModelNameMatrice600Pro)){
            DJISDKManager.videoFeeder()?.secondaryVideoFeed.add(self, with: nil)
        }else{
            DJISDKManager.videoFeeder()?.primaryVideoFeed.add(self, with: nil)
        }
        VideoPreviewer.instance().start()
    }
    
    func resetVideoPreview() {
        VideoPreviewer.instance().unSetView()
        let product = DJISDKManager.product();
        
        //Use "SecondaryVideoFeed" if the DJI Product is A3, N3, Matrice 600, or Matrice 600 Pro, otherwise, use "primaryVideoFeed".
        if ((product?.model == DJIAircraftModelNameA3)
            || (product?.model == DJIAircraftModelNameN3)
            || (product?.model == DJIAircraftModelNameMatrice600)
            || (product?.model == DJIAircraftModelNameMatrice600Pro)){
            DJISDKManager.videoFeeder()?.secondaryVideoFeed.remove(self)
        }else{
            DJISDKManager.videoFeeder()?.primaryVideoFeed.remove(self)
        }
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

extension PilotHUDViewController: DJIVideoFeedListener{
    
    func videoFeed(_ videoFeed: DJIVideoFeed, didUpdateVideoData rawData: Data) {
        
        let videoData = rawData as NSData
        let videoBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: videoData.length)
        videoData.getBytes(videoBuffer, length: videoData.length)
        VideoPreviewer.instance().push(videoBuffer, length: Int32(videoData.length))
    }
    
}


extension PilotHUDViewController: DJICameraDelegate{
    func camera(_ camera: DJICamera, didUpdate cameraState: DJICameraSystemState) {
        self.isRecording = cameraState.isRecording
//        self.recordTimeLabel.isHidden = !self.isRecording
//        
//        self.recordTimeLabel.text = formatSeconds(seconds: cameraState.currentVideoRecordingTimeInSeconds)
        
        if (self.isRecording == true) {
//            self.recordButton.setTitle("Stop Record", for: UIControlState.normal)
        } else {
//            self.recordButton.setTitle("Start Record", for: UIControlState.normal)
        }
        
        //Update UISegmented Control's State
        if (cameraState.mode == DJICameraMode.shootPhoto) {
//            self.workModeSegmentControl.selectedSegmentIndex = 0
        } else {
//            self.workModeSegmentControl.selectedSegmentIndex = 1
        }
        
    }
}
