//
//  WebSocketClient.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/25.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
//import SocketIO
import Starscream



class WebSocketManager : NSObject, WebSocketDelegate {
    
    var socket : WebSocket?
    let socketURL = URL(string: "https://simple-beacon-socket.herokuapp.com/")!
    private static var _sharedInstance : WebSocketManager?
    
    class func sharedInstance() -> WebSocketManager {
        if _sharedInstance != nil{
            return _sharedInstance!
        }else{
            _sharedInstance = WebSocketManager()
            return _sharedInstance!
        }
    }
    
    override init() {
        super.init()
    }
    
    func connect() {
        socket = WebSocket(url: URL(string: "wss://simple-beacon-socket.herokuapp.com/")!, protocols: ["chat","superchat"])
        
        // Set enabled cipher suites to AES 256 and AES 128
        socket!.enabledSSLCipherSuites = [TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256]
        socket!.delegate = self
        socket!.connect()
    }
    

    func websocketDidConnect(socket: WebSocketClient) {
        print(socket)
        print("connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect")
        socket.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDidReceiveMessage")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData")
    }
    
    func sendMessage(log : PeripheralLog) {
        let message = makeMessage(log: log)
        self.socket!.write(string: "{\(message)}")
    }
    
//    let major : Int
//    let minor : Int
//    let rssi : Int
//    let deviceToken : String
//    let detectedAt : Date
//    let location : String
    
    func makeMessage(log : PeripheralLog) -> String{
        return "\"major\":\(log.major),\"minor\":\(log.minor),\"rssi\":\(log.rssi),\"serviceToken\":\"\(log.serviceToken)\",\"deviceToken\":\"\(log.deviceToken)\",\"detectedAt\":\"\(log.detectedAt)\",\"location\":\"\(log.location)\""
    }

}
