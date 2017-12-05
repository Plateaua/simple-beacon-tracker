//
//  UserNotificationManager.swift
//  Tracker
//
//  Created by Takano Masanori on 2017/11/17.
//  Copyright © 2017年 Takano Masanori. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
//UserAttension.removeLocalNotifications(identifier: identifier)
//UserAttension.setLocalNotification(message: "\(mamorio.name!)\(NSLocalizedString("IsYourMAMORIOAtYourHand?",comment: "は手元にありますか？"))", identifier: identifier)

class UserNotificationManager{
    
    // TODO: 通知を許可しなかった時にpresentSecondAlert()を呼び出す処理をついかすること！
    static func authLocalNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.getNotificationSettings(completionHandler: { settings in
//                guard let strongSelf = self else { return }
                
                switch settings.authorizationStatus {
                case .notDetermined:
                    let options: UNAuthorizationOptions =  [.alert, .badge, .sound]
                    center.requestAuthorization(options: options, completionHandler: { (granted, error) in
                        print(granted, error as Any)
                        
                    })
                case .authorized:
//                    strongSelf.finishAuthorizationFlow()
                    break
                case .denied:
//                    strongSelf.presentSecondAlert()
                    break
                }
            })
        } else {
        
        }
    }
    
    /**
     ローカル通知により、メッセージをユーザーに通知する
     - parameter message:　通知に表示する文字列
     */
    static func doLocalNotification(message : String, identifier : String){
        
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            
            content.body = message
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
        }else{
            let notification:UILocalNotification = UILocalNotification.init()
            notification.fireDate = Date()
            notification.timeZone = TimeZone.current
            notification.alertBody = message
            notification.alertAction = "Open"
            notification.userInfo = ["id" : message]
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    static func removeLocalNotifications(identifier : String){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeDeliveredNotifications(withIdentifiers: [identifier])
            
        }else{
            let app = UIApplication.shared
            //通知されてないnotificationを取得
            let notifications = app.scheduledLocalNotifications
            //一度全てキャンセル
            app.cancelAllLocalNotifications()
            //通知されてないnotification
            notifications?.forEach({notification in
                app.scheduleLocalNotification(notification)
            })
        }
    }
}

