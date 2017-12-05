//
//  Location.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/26.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreLocation

struct Location :Codable {
    let latitude : Double
    let longitude : Double
    let accuracy : Double
    let createdAt : Date

    init(_location : CLLocation) {
        latitude = _location.coordinate.latitude
        longitude = _location.coordinate.longitude
        accuracy = _location.horizontalAccuracy
        createdAt = Date()
    }
}
