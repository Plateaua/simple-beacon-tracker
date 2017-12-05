//
//  BeaconServiceManager.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/12.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import UIKit

class BeaconServiceManager: NSObject, CBCentralManagerDelegate, ScannerDelegate, BeaconMonitorDelegate, LocationMonitorDelegate {
    
    internal var scanner : Scanner?
    internal var beaconMonitor : BeaconMonitor?
    internal var locationMonitor : LocationMonitor?
    internal var proximityUUID : String?
    internal var deviceToken : String?
    internal var serviceToken : String?

    fileprivate var centralManager: CBCentralManager?
    
    var rangingSuccess:(() -> ())?
    var rangingFailed:((_ error : Error) -> ())?
    var foundBeacons:(([CLBeacon]) -> ())?

    func startServices(proximityUUID : String, deviceToken: String, serviceToken: String, success :@escaping ()->Void, fail :@escaping (_ error : Error)->Void, found : @escaping (_ beacons: [CLBeacon]) -> Void) {
        self.rangingSuccess = success
        self.rangingFailed = fail
        self.foundBeacons = found
        self.proximityUUID = proximityUUID
        self.deviceToken = deviceToken
        self.serviceToken = serviceToken
        Emitter.sharedInstance().start()
        self.checkBluetoothStatus()
    }
    
    func checkBluetoothStatus(){
        let options = [
            CBCentralManagerOptionShowPowerAlertKey : NSNumber.init(value: true)]
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: options)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            startScanner()
            break
        case .poweredOff:
            break
        case .unsupported:
            break
        case .unknown:
            //スルー
            break
        case .resetting:
            //The connection with the system service was momentarily lost; an update is imminent.
            //https://developer.apple.com/reference/corebluetooth/cbcentralmanagerstate/1518863-resetting
            break
        case .unauthorized:
            break
        }
    }
    
    func startScanner(){
        UserNotificationManager.authLocalNotification()
        self.scanner = Scanner(delegate: self)
        self.scanner?.startRanging(proximityUUID: self.proximityUUID!, serviceToken: self.serviceToken!, deviceToken: self.deviceToken!)
        self.beaconMonitor = BeaconMonitor(delegate: self)
        self.beaconMonitor?.startMonitoring(proximityUUID: self.proximityUUID!)
        self.locationMonitor = LocationMonitor(delegate: self)
        self.locationMonitor?.startUpdatingLocation()
        WebSocketManager.sharedInstance().connect()
    }
    
    func didRangeBeacons(beacons: [CLBeacon]) {
        if (foundBeacons != nil) {
            foundBeacons!(beacons)
        }
    }
    
    func didFailWithError(error: Error) {
        if rangingFailed != nil {
            rangingFailed!(error)
        }
    }
    
    func didStartMonitoringFor() {
        UserNotificationManager.removeLocalNotifications(identifier: "fuck")
        UserNotificationManager.doLocalNotification(message: "didStartMonitoring", identifier: "fuck")
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didStartMonitoring", _detectedAt: Date())])
    }
    
    func monitoringDidFailFor(error: Error) {
        UserNotificationManager.removeLocalNotifications(identifier: "fuck")
        UserNotificationManager.doLocalNotification(message: "monitoringDidFailFor", identifier: "fuck")
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "monitoringDidFailFor", _detectedAt: Date())])

    }
    
    func didDetermineState(status: CLRegionState) {
        UserNotificationManager.removeLocalNotifications(identifier: "fuck")
        UserNotificationManager.doLocalNotification(message: "didDetermineState \(status.rawValue)", identifier: "fuck")
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didDetermineState", _detectedAt: Date())])
    }
    
    func didEnterRegion(region: CLRegion) {
        UserNotificationManager.removeLocalNotifications(identifier: "fuck")
        UserNotificationManager.doLocalNotification(message: "didEnterRegion", identifier: "fuck")
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didEnterRegion", _detectedAt: Date())])
    }
    
    func didExitRegion(region: CLRegion) {
        UserNotificationManager.removeLocalNotifications(identifier: "fuck")
        UserNotificationManager.doLocalNotification(message: "didExitRegion", identifier: "fuck")
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didExitRegion", _detectedAt: Date())])
    }
    
    func didUpdateLocations(locations: [CLLocation]) {
        UserNotificationManager.removeLocalNotifications(identifier: "fuck")
        UserNotificationManager.doLocalNotification(message: "didUpdateLocations", identifier: "fuck")
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didUpdateLocations", _detectedAt: Date())])
    }
}
