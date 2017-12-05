//
//  Emitter.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/11.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
class Emitter {
    
    private static var _sharedInstance : Emitter?
    let logSendingInterval : Int = 1
    var lastSendAt : Date?
    var timer: Timer!

    class func sharedInstance() -> Emitter {
        if _sharedInstance != nil{
            return _sharedInstance!
        }else{
            _sharedInstance = Emitter()
            return _sharedInstance!
        }
    }
    
    public func start() {
        if self.timer != nil && self.timer.isValid{
            self.timer.invalidate()
        }
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(logSendingInterval), target: self, selector: #selector(self.sendLogs), userInfo: nil, repeats: true)
    }

    @objc func sendLogs(){
        let storedLogs = PeripheralLogFileManager.loadLocal()
        print("logs sent started \(storedLogs.count)")
        storedLogs.forEach { (log) in
            WebSocketManager.sharedInstance().sendMessage(log: log)
        }
        PeripheralLogFileManager.deleteLocal()
    }
}
