//
//  EventLog.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/13.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreLocation

struct EventLog :Codable {
    let description : String
    let detectedAt : Date
    
    init(_description: String, _detectedAt : Date) {
        description = _description
        detectedAt = _detectedAt
    }
}
