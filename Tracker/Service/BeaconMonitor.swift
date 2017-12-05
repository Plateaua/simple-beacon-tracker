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

public protocol BeaconMonitorDelegate: class {
    func didStartMonitoringFor()
    func monitoringDidFailFor(error: Error)
    func didDetermineState(status:CLRegionState)
    func didEnterRegion(region:CLRegion)
    func didExitRegion(region:CLRegion)
}

class BeaconMonitor: NSObject, CLLocationManagerDelegate {
    
    fileprivate weak var delegate: BeaconMonitorDelegate? = nil
    
    open var locationManager: CLLocationManager?

    init(delegate : BeaconMonitorDelegate){
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
    
    func startMonitoring(proximityUUID : String) {
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: proximityUUID)!, identifier: "")
        locationManager?.startMonitoring(for: region)
    }
        
    func stopAllMonitoring(){
        if self.locationManager?.monitoredRegions != nil{
            for region in (self.locationManager?.monitoredRegions)!{
                self.locationManager?.stopMonitoring(for: region)
            }
        }
    }
    
    internal func resetMonitoring(){
        self.stopAllMonitoring()
//        self.startMonitoring()
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        delegate?.didStartMonitoringFor()
        // この時点でビーコンがすでにRegion内に入っている可能性があるので、その問い合わせを行う
        manager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        delegate?.monitoringDidFailFor(error: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        delegate?.didDetermineState(status: state)
        switch state {
        case .inside:
            break
        case .outside, .unknown:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        delegate?.didEnterRegion(region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        delegate?.didExitRegion(region: region)
    }
}


