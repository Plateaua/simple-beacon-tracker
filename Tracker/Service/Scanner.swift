//
//  Scanner.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/11.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation
import UIKit

public protocol ScannerDelegate: class {
    func didRangeBeacons(beacons: [CLBeacon])
    func didFailWithError(error:Error)
}

class Scanner: NSObject, CLLocationManagerDelegate {
    
    fileprivate weak var delegate: ScannerDelegate? = nil
    private var beaconRegion: CLBeaconRegion?
    
    open var locationManager: CLLocationManager?
    
    fileprivate var beacons = [CLBeacon]()
    
    var rangingFailed:((_ error : NSError) -> ())?
    var rangingSuccess:(() -> ())?
    var stopRangingFlag : Bool = false
    var deviceToken : String?
    var serviceToken : String?

    init(delegate: ScannerDelegate){
        super.init()
        self.delegate = delegate
        self.locationManager = self.makeLocationManager()
    }
    
    func makeLocationManager() -> CLLocationManager {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        return locationManager
    }
    
    func startRanging(proximityUUID : String, serviceToken: String, deviceToken: String ) {
        self.serviceToken = serviceToken
        self.deviceToken = deviceToken
        self.locationManager?.requestAlwaysAuthorization()
        self.beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: proximityUUID)!, identifier: proximityUUID)
        self.locationManager!.startRangingBeacons(in: self.beaconRegion!)
    }
    
    func stopRanging() {
        if let locationManager = self.locationManager {
            locationManager.stopRangingBeacons(in: self.beaconRegion!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didRangeBeacons", _detectedAt: Date())])
        
        let beaconsWithinACertainDistance = beacons.filter({ (beacon) -> Bool in
            beacon.rssi < 0
        })
        
//        let x = Array(beaconsWithinACertainDistance[0...10])
        Packer(serviceToken: self.serviceToken!, deviceToken: self.deviceToken!).pack(beacons: beaconsWithinACertainDistance)
        delegate?.didRangeBeacons(beacons: beaconsWithinACertainDistance)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailWithError(error: error)
    }
}
