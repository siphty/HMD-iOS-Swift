//
//  PilotModeViewController.swift
//  HMD
//
//  Created by Yi JIANG on 12/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import DJISDK

class PilotModeViewController: UIViewController {
    weak var appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var productConnectionStatus: UILabel!
    @IBOutlet weak var productModel: UILabel!
    @IBOutlet weak var productFirmwarePackageVersion: UILabel!
    @IBOutlet weak var openComponents: UIButton!
    @IBOutlet weak var bluetoothConnectorButton: UIButton!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var bridgeModeLabel: UILabel!
    
    @IBAction func ConnectButtonTouchUpInside(_ sender: Any) {
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        print("Try to connect product")
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
                    }
                }
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey, withListener: self, andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                if newValue != nil {
                    if newValue!.boolValue {
                        // At this point, a product is connected so we can show it.
                        
                        // UI goes on MT.
                        DispatchQueue.main.async {
                            self.productConnected()
                        }
                    }
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        DJISDKManager.keyManager()?.stopAllListening(ofListeners: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func resetUI() {
        self.title = "DJI iOS SDK Sample"
        self.sdkVersionLabel.text = "DJI SDK Version: \(DJISDKManager.sdkVersion())"
        self.openComponents.isEnabled = true; //FIXME: set it back to false
        self.bluetoothConnectorButton.isEnabled = true;
        self.productModel.isHidden = true
        self.productFirmwarePackageVersion.isHidden = true
        self.bridgeModeLabel.isHidden = !self.appDelegate.productCommunicationManager.enableBridgeMode
        
        if self.appDelegate.productCommunicationManager.enableBridgeMode {
            self.bridgeModeLabel.text = "Bridge: \(self.appDelegate.productCommunicationManager.bridgeAppIP)"
        }
    }
    
    func showAlert(_ msg: String?) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
            print("Alert dismissed with action: \(UIAlertAction.debugDescription)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func productConnected() {
        guard let newProduct = DJISDKManager.product() else {
            NSLog("Product is connected but DJISDKManager.product is nil -> something is wrong")
            return;
        }
        
        //Updates the product's model
        self.productModel.text = "Model: \((newProduct.model)!)"
        self.productModel.isHidden = false
        
        //Updates the product's firmware version - COMING SOON
        newProduct.getFirmwarePackageVersion{ (version:String?, error:Error?) -> Void in
            
            self.productFirmwarePackageVersion.text = "Firmware Package Version: \(version ?? "Unknown")"
            
            if let _ = error {
                self.productFirmwarePackageVersion.isHidden = true
            }else{
                self.productFirmwarePackageVersion.isHidden = false
            }
            
            NSLog("Firmware package version is: \(version ?? "Unknown")")
        }
        
        //Updates the product's connection status
        self.productConnectionStatus.text = "Status: Product Connected"
        
        self.openComponents.isEnabled = true;
        self.openComponents.alpha = 1.0;
        NSLog("Product Connected")
    }
    
    func productDisconnected() {
        self.productConnectionStatus.text = "Status: No Product Connected"
        
        self.openComponents.isEnabled = false;
        self.openComponents.alpha = 0.8;
        NSLog("Product Disconnected")
    }


}
