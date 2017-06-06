//
//  DroneViewController.swift
//  HMD
//
//  Created by Yi JIANG on 5/6/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import DJISDK

class DroneViewController: UIViewController {
    weak var appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var productConnectionStatus: UILabel!
    @IBOutlet weak var productModel: UILabel!
    @IBOutlet weak var productFirmwarePackageVersion: UILabel!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var bridgeModeLabel: UILabel!
    @IBOutlet weak var droneImageView: UIImageView! = {
       var droneImageView = UIImageView()
        droneImageView.layer.borderWidth = 4
        droneImageView.layer.borderColor = UIColor.green.cgColor
        return droneImageView
    }()
    
    let shadowView: UIView = {
        let shadowView = UIView()
        shadowView.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor
        shadowView.layer.borderWidth = 3
        return shadowView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        
        bridgeModeLabel.isHidden = !appDelegate.productCommunicationManager.enableBridgeMode
        if !bridgeModeLabel.isHidden {
            bridgeModeLabel.text = "Bridge: \(appDelegate.productCommunicationManager.bridgeAppIP)"
        }
        productFirmwarePackageVersion.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey,
                                                                 withListener: self,
                                                                 andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                if newValue != nil {
                    if newValue!.boolValue {
                        // At this point, a product is connected so we can show it.
                        
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected()
                        }
                    } else {
                        self.productDisconnected()
                    }
                }
            })
        }
        
        shadowView.bounds = CGRect(x: 0, y: 0, width: #imageLiteral(resourceName: "DJI P4").size.width, height: #imageLiteral(resourceName: "DJI P4").size.height)
        shadowView.center = droneImageView.center
        shadowView.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        shadowView.layer.doMask(by: #imageLiteral(resourceName: "DJI P4"))
        droneImageView.image = nil
        droneImageView.addSubview(shadowView)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
//        droneImageView.image = getDroneImage(of: "Spark")
        connectProduct()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ConnectButtonTouchUpInside(_ sender: Any) {
        if self.appDelegate.productCommunicationManager.enableBridgeMode {
            NSLog("Connecting to Product using debug IP address: \(self.appDelegate.productCommunicationManager.bridgeAppIP)...")
            DJISDKManager.enableBridgeMode(withBridgeAppIP: self.appDelegate.productCommunicationManager.bridgeAppIP)
        }
        bridgeModeLabel.isHidden = !appDelegate.productCommunicationManager.enableBridgeMode
        if appDelegate.productCommunicationManager.enableBridgeMode {
            bridgeModeLabel.text = "Bridge: \(appDelegate.productCommunicationManager.bridgeAppIP)"
        }
        connectProduct()
    }
    
    func connectProduct(){
        let startedResult = DJISDKManager.startConnectionToProduct()
        if startedResult {
            NSLog("Connecting to product started successfully!")
            productConnected()
        } else {
            NSLog("Connecting to product failed to start!")
            productDisconnected()
        }
    }
    
    func productConnected() {
        guard let newProduct = DJISDKManager.product() else {
            NSLog("Product is connected but DJISDKManager.product is nil -> something is wrong")
            return;
        }
        
        //Updates the product's model
                self.productModel.text = "\((newProduct.model)!)"
                self.productModel.isHidden = false
        
        //Updates the product's firmware version - COMING SOON
        newProduct.getFirmwarePackageVersion{ (version:String?, error:Error?) -> Void in
            self.productFirmwarePackageVersion.text = "Firmware Version: \(version ?? "Unknown")"
            if let _ = error {
                                self.productFirmwarePackageVersion.isHidden = true
            }else{
                                self.productFirmwarePackageVersion.isHidden = false
            }
        }
        
        //Updates the product's connection status
        self.productConnectionStatus.text = "CONNECTED"
        self.productConnectionStatus.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        
        //Update backgound drone image
        shadowView.removeFromSuperview()
        droneImageView.image = getDroneImage(of: newProduct.model!)
        NSLog("Product Connected")
        
        //Update Bridge Moddl label
        
        bridgeModeLabel.isHidden = !appDelegate.productCommunicationManager.enableBridgeMode
        if appDelegate.productCommunicationManager.enableBridgeMode {
            bridgeModeLabel.text = "Bridge: \(appDelegate.productCommunicationManager.bridgeAppIP)"
        }
    }
    
    func productDisconnected() {
        //        self.productConnectionStatus.text = "Status: No Product Connected"
        //
        resetUI()
        NSLog("Product Disconnected")
    }
    
    func resetUI() {
        title = "Siphty"
        sdkVersionLabel.text = "SDK Version: \(DJISDKManager.sdkVersion())"
        
        
        productConnectionStatus.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.productConnectionStatus.text = "DISCONNECTED"
        productModel.isHidden = true
        productFirmwarePackageVersion.isHidden = true
        bridgeModeLabel.isHidden = !appDelegate.productCommunicationManager.enableBridgeMode
        
        if appDelegate.productCommunicationManager.enableBridgeMode {
            bridgeModeLabel.text = "Bridge: \(appDelegate.productCommunicationManager.bridgeAppIP)"
        }
        
        shadowView.bounds = CGRect(x: 0, y: 0, width: #imageLiteral(resourceName: "DJI P4").size.width, height: #imageLiteral(resourceName: "DJI P4").size.height)
        shadowView.center = droneImageView.center
        shadowView.layer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        shadowView.layer.doMask(by: #imageLiteral(resourceName: "DJI P4"))
        droneImageView.image = nil
        droneImageView.addSubview(shadowView)
        
    }
    
    func getDroneImage(of model: String) -> UIImage{
        var droneImage = UIImage()
        if model == "Phantom 4" {
            droneImage = #imageLiteral(resourceName: "DJI P4")
        } else if model == "unknown" {
            droneImage = #imageLiteral(resourceName: "DJI Unidentified Flying Object")
        } else if model == "Inspire 1" {
            droneImage = #imageLiteral(resourceName: "DJI Inspire 1")
        } else if model == "Inspire 1 Pro" {
            droneImage = #imageLiteral(resourceName: "DJI Inspire 1 Pro")
        } else if model == "Inspire 1 Raw" {
            droneImage = #imageLiteral(resourceName: "DJI Inspire 1 Pro")
        } else if model == "Inspire 2" {
            droneImage = #imageLiteral(resourceName: "DJI Inspire 2")
        } else if model == "Phantom 3 Professional" {
            droneImage = #imageLiteral(resourceName: "DJI P3 Pro")
        } else if model == "Phantom 3 Advanced" {
            droneImage = #imageLiteral(resourceName: "DJI P3 Adv")
        } else if model == "Phantom 3 Standard" {
            droneImage = #imageLiteral(resourceName: "DJI P3 Standard")
        } else if model == "Phantom 4 Pro" {
            droneImage = #imageLiteral(resourceName: "DJI P4 Pro")
        } else if model == "Matrice 100" {
            droneImage = #imageLiteral(resourceName: "DJI Matrice 100")
        } else if model == "Matrice 200" {
            droneImage = #imageLiteral(resourceName: "DJI Matrice 200")
        } else if model == "Phantom 4 Advanced" {
            droneImage = #imageLiteral(resourceName: "DJI P4 Adv")
        } else if model == "Matrice 600" {
            droneImage = #imageLiteral(resourceName: "DJI Matrice 600")
        } else if model == "Matrice 600 Pro" {
            droneImage = #imageLiteral(resourceName: "DJI Matrice 600 pro")
        } else if model == "A3" {
            droneImage = #imageLiteral(resourceName: "DJI A3")
        } else if model == "Mavic Pro" {
            droneImage = #imageLiteral(resourceName: "DJI Mavic Pro")
        } else if model == "N3" {
            droneImage = #imageLiteral(resourceName: "DJI N3")
        } else if model == "Spark" {
            droneImage = #imageLiteral(resourceName: "DJI Spark")
        } else {
            droneImage = #imageLiteral(resourceName: "DJI Unidentified Flying Object")
        }
        return droneImage
    }
    
    
}
