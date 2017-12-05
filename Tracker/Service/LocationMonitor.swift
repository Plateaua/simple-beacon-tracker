//
//  LocationMonitor.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/12.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreLocation


public protocol LocationMonitorDelegate: class {
    func didUpdateLocations(locations: [CLLocation])
}

class LocationMonitor : NSObject, CLLocationManagerDelegate{

    fileprivate weak var delegate: LocationMonitorDelegate? = nil
    fileprivate var lastLocation: CLLocation?
    var locationManager: CLLocationManager?
    var locerror: NSError?
    var lastDetectedAt: Date?
    
    var locationUpdatingFailed:((_ error : NSError) -> ())?
    var locationUpdatingSuccess:(() -> ())?
    var success = false
    
    init(delegate: ScannerDelegate){
        super.init()
        self.locationManager = self.makeLocationManager()
        self.authorizationStatusCheck()
    }
    //ユーザーが移動しない（stationaly）の時にはaccuracyを下げて電池消費を低減させようと思ったけど、著しく品質が悪くなるので保留
    func restartRazy(){
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager?.activityType = CLActivityType.other
        self.locationManager?.startUpdatingLocation()
        print("restartRazy")
    }
    //
    func restartDiligent(){
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.activityType = CLActivityType.other
        self.locationManager?.startUpdatingLocation()
        print("restartDiligent")
    }
    
    func makeLocationManager() -> CLLocationManager {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = CLActivityType.other
        locationManager.distanceFilter = 30.0
        return locationManager
    }
    
    func startUpdatingLocation() {
        self.authorizationStatusCheck()
    }
    
    func authorizationStatusCheck() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            self.locationManager!.startUpdatingLocation()
            if self.locationUpdatingSuccess != nil && success == false{
                success = true
                self.locationUpdatingSuccess!()
            }
            
        case .authorizedWhenInUse:
            self.locationManager!.requestAlwaysAuthorization()
            self.locationManager!.startUpdatingLocation()
            if self.locationUpdatingSuccess != nil && success == false{
                success = true
                self.locationUpdatingSuccess!()
            }
            break
        case .notDetermined:
            // self.locationManager!.requestAlwaysAuthorization()
            self.locationManager!.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
                let error = NSError.init(domain: "LocationAuthorizationError", code: NSURLErrorUnknown, userInfo: ["error_message": "位置情報サービスの利用が許可されていません。設定画面から利用を許可してください。"])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways:
            self.locationManager!.startUpdatingLocation()
        case .authorizedWhenInUse:
            self.locationManager!.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            self.locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations) \(Date())")
        delegate?.didUpdateLocations(locations: locations)
        EventLogFileManager.saveLocal(logs: [EventLog(_description: "didUpdateLocations", _detectedAt: Date())])
        if let location = locations.first {
            LocationFileManager.deleteLocal()
            LocationFileManager.saveLocal(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationerror:\(error)")
    }
    
    func isForbiddenBackgroundRanging() -> Bool {
        return false
    }
    
    func  locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?){
    }
}
