//
//  PeripheralLogFileManager.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/12.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
class PeripheralLogFileManager{
    
    private class func filePath() -> URL?{
        let cacheDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last
        if let filePath = cacheDirectoryURL?.appendingPathComponent("\(PeripheralLog.self)"){
            return filePath
        }else{
            return nil
        }
    }
    
    static func saveLocal(logs : [PeripheralLog]) -> () {
        do{
            let jsonData = try JSONEncoder().encode(logs)
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
    
    static func loadLocal() -> [PeripheralLog] {
        if let filePath =  filePath() {
//            if FileManager.default.fileExists(atPath: filePath.absoluteString){
                do {
                    let jsonData = try Data(contentsOf: filePath)
                    do {
                        let decodedLogs: [PeripheralLog] = try JSONDecoder().decode([PeripheralLog].self, from: jsonData)
                        return decodedLogs
                    }
                }catch let error as NSError{
                    print("Load local failed! \(error)")
                }
//            }
        }
        return [PeripheralLog] ()
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
