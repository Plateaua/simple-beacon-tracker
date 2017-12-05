//
//  LocationFileManager.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/26.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import CoreLocation
class LocationFileManager{
    
    private class func filePath() -> URL?{
        let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
        if let filePath = cacheDirectoryURL?.appendingPathComponent("\(Location.self)"){
            return filePath
        }else{
            return nil
        }
    }
    
    static func saveLocal(location : CLLocation) -> () {
        do{
            
            let jsonData = try JSONEncoder().encode(Location(_location: location))
            let jsonString = String(data: jsonData, encoding: .utf8)
            
            if let filePath = filePath(){
                do {
                    try jsonString?.write(to: filePath, atomically: true, encoding: .utf8)
                } catch  let error as NSError{
                    print("Save local failed! \(error)")
                }
            }else{
                print("Filepath not found")
            }
        }
        catch let error as NSError{
            print("Log encoding failed! \(error)")
        }
    }
    
    static func loadLocal() -> Location? {
        if let filePath =  filePath() {
            //            if FileManager.default.fileExists(atPath: filePath.absoluteString){
            do {
                let jsonData = try Data(contentsOf: filePath)
                do {
                    let decodedLocation: Location = try JSONDecoder().decode(Location.self, from: jsonData)
                    return decodedLocation
                }
            }catch let error as NSError{
                print("Load local failed! \(error)")
            }
            //            }
        }
        return nil
    }
    
    static func deleteLocal() {
        if let filePath = filePath(){
            do {
                try FileManager.default.removeItem(at: filePath)
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
        }
    }
}
