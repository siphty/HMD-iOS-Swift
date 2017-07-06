//
//  SystemInforTableViewController.swift
//  HMD
//
//  Created by Yi JIANG on 16/5/17.
//  Copyright © 2017 RobertYiJiang. All rights reserved.
//

import UIKit
import DJISDK



class SystemInforTableViewController: UITableViewController {
    
    weak var appDelegate: AppDelegate! = UIApplication.shared.delegate as? AppDelegate
    var productFirmwarePackageVersion: String?
    var aircraft: DJIBaseProduct?
    //Managers
    var flyZone: DJIFlyZoneManager?
    var keyManager: DJIKeyManager?
    var missionControl: DJIMissionControl?
    var videoFeeder: DJIVideoFeeder?
    
    //Flight Control
    var flightControl: DJIFlightController?
    var flightControlKey: DJIFlightControllerKey?
    @IBAction func close () {
        self.dismiss(animated: true) {
        }
    }
    //Gimbal
    var gimbal: DJIGimbal?
    
//    var flightControl = DJIflig
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(UINib(nibName: "CommonDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "CommonDetailCell")
        

        guard let connectedKey = DJIProductKey(param: DJIParamConnection) else {
            NSLog("Error creating the connectedKey")
            return;
        }
        DJISDKManager.keyManager()?.startListeningForChanges(on: connectedKey,
                                                             withListener: self,
                                                             andUpdate: { (oldValue: DJIKeyedValue?, newValue : DJIKeyedValue?) in
                                                                if newValue != nil {
                                                                    if newValue!.boolValue {
                                                                        // At this point, a product is connected so we can show it.
                                                                        
                                                                        // UI goes on MT.
                                                                        DispatchQueue.main.async {
                                                                            self.productConnected()
                                                                            print("Try to connect product")
                                                                        }
                                                                    }
                                                                }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectDeviceItemSelector(_ sender: Any) {
        print("Try to update product status")
        self.tableView.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SystemSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsInSection: Int
        
        switch SystemSection.withIndex(section) {
        case .app:
            rowsInSection = AppAndiPhone.count
        case .aircraft:
            rowsInSection = Aircraft.count
        case .flightController:
            rowsInSection = FlightController.count
        case .camera:
            rowsInSection = Camere.count
        case .remoteController:
            rowsInSection = RemoteController.count
        case .battery:
            rowsInSection = Battery.count
        case .gimbal:
            rowsInSection = Gimbal.count
        case .airLink:
            rowsInSection = AirLink.count
        }
        return rowsInSection
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleView = UIView()
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 5, y: 5, width: 200, height: 30)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        var sectionTitle: String?
        
        switch SystemSection.withIndex(section) {
        case .app:
            sectionTitle = "App And iPhone"
        case .aircraft:
            sectionTitle = "Aircraft"
        case .flightController:
            sectionTitle = "Flight Controller"
        case .camera:
            sectionTitle = "Camera"
        case .remoteController:
            sectionTitle = "Remote Controller"
        case .battery:
            sectionTitle = "Battery"
        case .gimbal:
            sectionTitle = "Gimbal"
        case .airLink:
            sectionTitle = "AirLink"
        }
        
        titleLabel.text = sectionTitle
        titleView.addSubview(titleLabel)
        
        return titleView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonDetailCell", for: indexPath) as! CommonDetailTableViewCell
        switch SystemSection.withIndex(indexPath.section) {
        case .app:
            switch indexPath.row {
            case AppAndiPhone.sdkVersion.rawValue:
                cell.title.text = "SDK Version"
                cell.details.text = DJISDKManager.sdkVersion()
            case AppAndiPhone.ipAddress.rawValue:
                cell.title.text = "iPhone IP Address"
//                cell.details.text = getIFAddresses()[1]
                cell.details.text = "10.0.0.20"
            case AppAndiPhone.appRegistered.rawValue:
                cell.title.text = "Registered"
                if DJISDKManager.hasSDKRegistered() {
                    cell.details.text = "YES"
                } else {
                    cell.details.text = "NO"
                }
            default:
                print("App and iPhone Details are overshoot")
            }
        case .aircraft:
            aircraft = DJISDKManager.product() as? DJIAircraft
            if aircraft == nil {
                cell.details.text = "Connect model is not ready."
                break
            }
            switch indexPath.row {
            case Aircraft.state.rawValue:
                cell.title.text = "State"
                cell.details.text = aircraft?.model ?? "N/A"

            case Aircraft.model.rawValue:
                cell.title.text = "Model"
                cell.details.text = aircraft?.model ?? "N/A"
            case Aircraft.connectMode.rawValue:
                cell.title.text = "Connect Mode"
                let enableBMode = appDelegate.djiProductCommunicationManager.enableBridgeMode
                if enableBMode {
                    cell.details.text = "Bridge"
                } else {
                    cell.details.text = "Direct"
                }
            case Aircraft.ipAddress.rawValue:
                cell.title.text = "IP Address"
                cell.details.text = appDelegate.djiProductCommunicationManager.bridgeAppIP
            case Aircraft.firmwareVersion.rawValue:
                cell.title.text = "Firmware Version"
                cell.details.text = productFirmwarePackageVersion ?? "N/A"
            default:
                print("Aircraft details is overshoot")
            }
        case .flightController:
            switch indexPath.row {
            case FlightController.compass.rawValue:
                print("compass heading 1 : \(flightControl?.compass?.heading.description ?? "Nil")")
                
                cell.title.text = "Compass Heading: "
                let compassKey = DJIFlightControllerKey(param: DJIFlightControllerParamCompassHeading)!
                let compassHeading = keyManager?.getValueFor(compassKey)?.value as? NSNumber
                let compassHeadingValue = compassHeading ?? 0
                print("Compass Heading 2: \(compassHeadingValue)")
                cell.details.text = "\(compassHeadingValue)"
            case FlightController.location.rawValue:
                flightControl?.getHomeLocation(completion: { (location, error) in
                print("location : \(location.latitude) : \(location.longitude)")
            })
                cell.title.text = "Location"
                guard let droneLocationKey = DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) else {
                    print("\(DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation).debugDescription)")
                    cell.details.text = "DJIFlightControllerKey(param: DJIFlightControllerParamAircraftLocation) == nil"
                    return cell
                }
                guard let droneLocationValue = DJISDKManager.keyManager()?.getValueFor(droneLocationKey) else {
                    print("Location: \(DJISDKManager.keyManager()?.getValueFor(droneLocationKey).debugDescription ?? "nil")")
                    cell.details.text = "getValueFor(droneLocationKey) == nil"
                    return cell
                }
                
                let droneLocation = droneLocationValue.value as! CLLocation
                cell.details.text = "Long: \(droneLocation.coordinate.longitude); Lati: \(droneLocation.coordinate.latitude)"
                
            default:
                cell.details.text = "N/A"
            }
            
        case .camera: break
        case .remoteController: break
        case .battery: break
        case .gimbal:
            switch indexPath.row {
            case Gimbal.state.rawValue:
                cell.title.text = "Status"
                
                guard let gimbalAttitudeKey = DJIGimbalKey(param: DJIGimbalParamAttitudeInDegrees) else {
                    print("DJIGimbalParamAttitudeInDegrees has problem")
                    cell.details.text = "DJIGimbalParamAttitudeInDegrees has problem"
                    return cell
                }
                guard let gimbalAttitudeValue = DJISDKManager.keyManager()?.getValueFor(gimbalAttitudeKey) else {
                    print("getValueFor(gimbalAttitudeKey)  has problem")
                    cell.details.text = "getValueFor(gimbalAttitudeKey)  has problem"
                    return cell
                }
                let gimbalAttitude = gimbalAttitudeValue.value as? DJIGimbalAttitude
                let yaw = gimbal?.attitudeInDegrees.yaw ?? 0
                let roll = gimbal?.attitudeInDegrees.roll ?? 0
                let pitch = gimbal?.attitudeInDegrees.pitch ?? 0
                cell.details.text = "Pitch: \(pitch); Yaw: \(yaw); Roll: \(roll)"

                
            default: break
            }
            
            
        case .airLink: break
        }
        
    
//        cell.textLabel?.text = "Row: \(indexPath.row) in Section: \(indexPath.section)"
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func productConnected() {
        if DJISDKManager.product() == nil {
            NSLog("Product is connected but DJISDKManager.product is nil -> something is wrong")
            return;
        }
        
        flyZone = DJISDKManager.flyZoneManager()
        if DJISDKManager.product() is DJIAircraft{
            aircraft = DJISDKManager.product() as? DJIAircraft
            gimbal = aircraft?.gimbal
            print("pitch: \(gimbal?.attitudeInDegrees.pitch ?? 0.0)")
        }
        keyManager = DJISDKManager.keyManager()
        flightControlKey = DJIFlightControllerKey.init()
        
        //Updates the product's firmware version - COMING SOON
        aircraft?.getFirmwarePackageVersion{ (version:String?, error:Error?) -> Void in
            
            self.productFirmwarePackageVersion = "\(version ?? "Unknown")"
        }


        self.tableView.reloadData()
    }
    
    
    func productDisconnected() {
        //        self.productConnectionStatus.text = "Status: No Product Connected"
        //
        //        self.openComponents.isEnabled = false;
        //        self.openComponents.alpha = 0.8;
        NSLog("Product Disconnected")
    }
}




enum SystemSection: Int {
    case app = 0
    case aircraft
    case flightController
    case camera
    case gimbal
    case remoteController
    case battery
    case airLink
    static let count: Int = {
        var max: Int = 0
        while let _ = SystemSection(rawValue: max) { max += 1 }
        return max
    }()
    
    static func withIndex(_ index: Int) -> SystemSection{
        switch index {
        case SystemSection.app.rawValue:
            return .app
        case SystemSection.aircraft.rawValue:
            return .aircraft
        case SystemSection.flightController.rawValue:
            return .flightController
        case SystemSection.camera.rawValue:
            return .camera
        case SystemSection.gimbal.rawValue:
            return .gimbal
        case SystemSection.remoteController.rawValue:
            return .remoteController
        case SystemSection.battery.rawValue:
            return .battery
        case SystemSection.airLink.rawValue:
            return .airLink
        default:
            return .app
        }
    }
}

enum AppAndiPhone: Int {
    case sdkVersion
    case ipAddress
    case appRegistered
    
    static let count: Int = {
        var max: Int = 0
        while let _ = AppAndiPhone(rawValue: max) { max += 1 }
        return max
    }()
}

enum Aircraft: Int {
    case state =  0
    case model
    case connectMode
    case ipAddress
    case firmwareVersion
    
    static let count: Int = {
        var max: Int = 0
        while let _ = Aircraft(rawValue: max) { max += 1 }
        return max
    }()
}

enum FlightController: Int {
    case state = 0
    case control
    case settings
    case compass
    case location
    case landingGear
    case simulator
    case rtk
    case flightLimitation
    case intelligentFlightAssistant
    static let count: Int = {
        var max: Int = 0
        while let _ = FlightController(rawValue: max) { max += 1 }
        return max
    }()
}

enum Camere: Int{
    case state = 0
    case control
    case settings
    case mediaOperations
    case storageOperations
    static let count: Int = {
        var max: Int = 0
        while let _ = Camere(rawValue: max) { max += 1 }
        return max
    }()
}

enum RemoteController: Int{
    case state = 0
    case settings
    case masterSlaveControl
    static let count: Int = {
        var max: Int = 0
        while let _ = RemoteController(rawValue: max) { max += 1 }
        return max
    }()
}

enum Battery: Int{
    case state = 0
    case settings
    static let count: Int = {
        var max: Int = 0
        while let _ = Battery(rawValue: max) { max += 1 }
        return max
    }()
}

enum Gimbal: Int{
    case state = 0
    case control
    case settings
    case caliberation
    static let count: Int = {
        var max: Int = 0
        while let _ = Gimbal(rawValue: max) { max += 1 }
        return max
    }()
}

enum AirLink: Int{
    case suportInfor
    case wifiLink
    case lbAirLink
    case suxLink
    case ocuSyncLink
    static let count: Int = {
        var max: Int = 0
        while let _ = AirLink(rawValue: max) { max += 1 }
        return max
    }()
}
