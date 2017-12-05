//
//  Packer.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/11.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreLocation
class Packer {

    let deviceToken : String
    let serviceToken : String

    init(serviceToken: String, deviceToken: String) {
        self.serviceToken = serviceToken
        self.deviceToken = deviceToken
    }

    func pack(beacons : [CLBeacon]) -> () {
 
        let location = LocationFileManager.loadLocal()
        var locationDescription : String = ""
        if location != nil {
            locationDescription = convertLocationToString(location: location!)
        }
        
        let logs = beacons.map { (beacon) -> PeripheralLog in
            PeripheralLog.init(beacon: beacon, _serviceToken: self.serviceToken, _deviceToken : self.deviceToken, _detectedAt : Date(), _location : locationDescription)
        }
        storeLocal(logs: logs)
    }
    
    func storeLocal(logs : [PeripheralLog]) -> () {
        let storedLogs = PeripheralLogFileManager.loadLocal()
        PeripheralLogFileManager.saveLocal(logs: storedLogs + logs)
    }
    
    func convertLocationToString(location : Location) -> String{
        return "\(location.latitude),\(location.longitude)"
    }
}
