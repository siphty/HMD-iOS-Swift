//
//  PilotHMDViewController.swift
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

class PilotHMDViewController: UIViewController {
    var isRecording : Bool!
    var hmdLayer = HMDLayer()
    var isSettingMode:Bool = false
    var previewerAdapter = VideoPreviewerSDKAdapter()
    
    @IBOutlet weak var returnButton: UIButton!
    
    @IBAction func close () {
        self.dismiss(animated: true) {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        VideoPreviewer.instance().start()
        VideoPreviewer.instance().setEnableBinocular(true)
        previewerAdapter = VideoPreviewerSDKAdapter.withDefaultSettings()
        previewerAdapter.start()
        
        let replicatorInstances = 2
        let replicatorViewWidth = (self.view.bounds.size.width / CGFloat(replicatorInstances))
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.frame = CGRect.init(x: 0.0,
                                            y: 0.0,
                                            width: replicatorViewWidth,
                                            height: self.view.bounds.height)
        replicatorLayer.instanceCount = replicatorInstances
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(replicatorViewWidth, 0.0, 0.0)
        
        hmdLayer.frame = replicatorLayer.bounds
        hmdLayer.borderWidth = 1
        hmdLayer.borderColor = UIColor.yellow.cgColor
        replicatorLayer.addSublayer(hmdLayer)
        view.layer.addSublayer(replicatorLayer)
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

extension PilotHMDViewController: DJICameraDelegate{
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

