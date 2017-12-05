//
//  PeripheralLog.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/11.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreLocation

struct PeripheralLog :Codable {
    let major : Int
    let minor : Int
    let rssi : Int
    let serviceToken : String
    let deviceToken : String
    let detectedAt : Date
    let location : String
    
    init(beacon : CLBeacon, _serviceToken : String, _deviceToken : String, _detectedAt : Date, _location : String) {
        major = beacon.major.intValue
        minor = beacon.minor.intValue
        rssi = beacon.rssi
        detectedAt = _detectedAt
        serviceToken = _serviceToken
        deviceToken = _deviceToken
        location = _location
    }
}
