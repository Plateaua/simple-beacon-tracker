//
//  ViewController.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/11.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    internal var beaconService : BeaconServiceManager?

    @IBOutlet weak var logLabel : UILabel!
    @IBOutlet weak var eventLabel : UILabel!
    @IBOutlet weak var uuidTextField : UITextField!
    @IBOutlet weak var serviceTokenTextField : UITextField!
    @IBOutlet weak var deviceTokenTextField : UITextField!
    @IBOutlet weak var rssiTextField : UITextField!
    @IBOutlet weak var rangingButton : UIButton!

    
    
    var rangingStarted : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uuidTextField.text = ProximityUUID
        self.rssiTextField.text = ""
        if let deviceToken = UserDefaults.standard.string(forKey: "deviceToken"){
            self.deviceTokenTextField.text = deviceToken
        }else{
            let deviceToken = randomString(length: 5)
            self.deviceTokenTextField.text = deviceToken
            UserDefaults.standard.set(deviceToken, forKey: "deviceToken")
        }        
        if let serviceToken = UserDefaults.standard.string(forKey: "serviceToken"){
            self.serviceTokenTextField.text = serviceToken
        }else{
            let serviceToken = randomString(length: 5)
            self.serviceTokenTextField.text = serviceToken
            UserDefaults.standard.set(serviceToken, forKey: "serviceToken")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showStoredLogs()
    }
    
    @IBAction func pushRangingButton(){
        showStoredLogs()
        self.beaconService = BeaconServiceManager()
        rangingButton.setTitle("now detecting beacons...", for: .normal)
        
        if self.uuidTextField == nil{
            return
        }

        if let deviceToken = self.deviceTokenTextField.text{
            UserDefaults.standard.set(deviceToken,forKey: "deviceToken")
            if let serviceToken = self.serviceTokenTextField.text{
                UserDefaults.standard.set(serviceToken,forKey: "serviceToken")
                self.beaconService?.startServices(proximityUUID: ProximityUUID, deviceToken: deviceToken, serviceToken: serviceToken, success: {() -> Void in
                    self.rangingStarted = true
                }, fail: {(error: Error) -> Void in
                    self.rangingStarted = false
                    self.rangingButton.setTitle("start ranging", for: .normal)
                }, found: {(beacons : [CLBeacon]) -> Void in
                    self.showStoredLogs()
                })
            }else{
                return
            }
        }else{
            return
        }
    }
    
    func showStoredLogs(){
        self.logLabel.text = ""
        var description = ""
        let storedLogs = PeripheralLogFileManager.loadLocal()
        var filterdLogs : [PeripheralLog]
        if Int(self.rssiTextField.text!) != nil {
            filterdLogs = storedLogs.filter({ (log) -> Bool in
                log.rssi != 0 && log.rssi > -Int(self.rssiTextField.text!)!
            })
        }else{
            filterdLogs = storedLogs
        }
        let sortedLogs = filterdLogs.sorted(by: { (logBefore, logAfter) -> Bool in
            logBefore.detectedAt > logAfter.detectedAt
        })
        sortedLogs.forEach({ (log) in
            description = "\(description)\n\(log.major)-\(log.minor) \(log.rssi) \(log.detectedAt)"
        })
        self.logLabel.text = description
        let storedEvent = EventLogFileManager.loadLocal()
        if let eventLog = storedEvent.first {
            self.eventLabel.text = "\(eventLog.description) \(eventLog.detectedAt)"
        }
    }
    
    @IBAction func showLogs(){
        self.showStoredLogs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }



}

