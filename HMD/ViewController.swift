//
//  ViewController.swift
//  HMD
//
//  Created by Yi JIANG on 17/2/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    var hmdLayer = HMDLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.loadCamera()
        //        self.startCamera(notifyLocationFailure: true)
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(
                                            deviceTypes: [AVCaptureDeviceType.builtInDualCamera,
                                                          AVCaptureDeviceType.builtInTelephotoCamera,
                                                          AVCaptureDeviceType.builtInWideAngleCamera],
                                            mediaType: AVMediaTypeVideo,
                                            position: AVCaptureDevicePosition.unspecified)
        for device in (deviceDiscoverySession?.devices)! {
            if(device.position == AVCaptureDevicePosition.back){
                do{
                    let input = try AVCaptureDeviceInput(device: device)
                    if(captureSession.canAddInput(input)){
                        captureSession.addInput(input)
                        
                        if(captureSession.canAddOutput(sessionOutput)){
                            let replicatorInstances = 2
                            
                            let replicatorViewWidth = (self.view.bounds.size.width / CGFloat(replicatorInstances))
                            let replicatorLayer = CAReplicatorLayer()
                            replicatorLayer.frame = CGRect.init(x: 0.0,
                                                                y: 0.0,
                                                                width: replicatorViewWidth,
                                                                height: self.view.bounds.height)
                            replicatorLayer.instanceCount = replicatorInstances
                            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(replicatorViewWidth, 0.0, 0.0)
                            
                            captureSession.addOutput(sessionOutput)
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
                            previewLayer.frame = replicatorLayer.frame
                            
                            hmdLayer.frame = previewLayer.bounds
                            hmdLayer.borderWidth = 1
                            hmdLayer.borderColor = UIColor.yellow.cgColor
                            previewLayer.addSublayer(hmdLayer)
                            hmdLayer.position = previewLayer.position
                            replicatorLayer.addSublayer(previewLayer)
                            view.layer.addSublayer(replicatorLayer)
                        }
                    }
                }
                catch{
                    print("exception!")
                }
            }
        }
        captureSession.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    
 }

