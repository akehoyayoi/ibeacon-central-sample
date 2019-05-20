//
//  NotificationManager.swift
//  Central
//
//  Created by YOHEI OKAYA on 2019/05/20.
//  Copyright © 2019 YOHEI OKAYA. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

struct NotificationManager {
    
    static let workCategoryIdentifier = "CATEGORY_WORK"
    static let homeCategoryIdentifier = "CATEGORY_HOME"
    static let workActionIdentifier = "ACTION_WORK"
    static let homeActionIdentifier = "ACTION_HOME"
    
    /**
     通知の許可を確認する
     */
    static func registerUserNotificationSettings() {
        if #available(iOS 10.0, *){
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.badge,.sound]) {granted, error in
                if error != nil {
                    // エラー時の処理
                    return
                }
            }
        } else {
            let application = UIApplication.shared
            application.registerUserNotificationSettings(settings())
        }
    }
    
    /**
     通知の許可を確認するときの設定を返す
     - returns: 通知の許可を確認するときの設定
     */
    private static func settings() -> UIUserNotificationSettings {
        let workAction = UIMutableUserNotificationAction()
        workAction.title = "出勤"
        workAction.identifier = workActionIdentifier
        workAction.activationMode = .foreground
        workAction.isDestructive = false
        workAction.isAuthenticationRequired = false
        
        let homeAction = UIMutableUserNotificationAction()
        homeAction.title = "退勤"
        homeAction.identifier = homeActionIdentifier
        homeAction.activationMode = .foreground
        homeAction.isDestructive = false
        homeAction.isAuthenticationRequired = false
        
        let workCategory = UIMutableUserNotificationCategory()
        workCategory.identifier = workCategoryIdentifier
        workCategory.setActions([workAction], for: .default)
        
        let homeCategory = UIMutableUserNotificationCategory()
        homeCategory.identifier = homeCategoryIdentifier
        homeCategory.setActions([homeAction], for: .default)
        
        let categories: Set = [workCategory, homeCategory]
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: categories)
        
        return notificationSettings
    }
    
    /**
     前回の通知から一定時間以上経過していればローカル通知を飛ばす
     
     - parameter message:  表示メッセージ
     - parameter category: 通知のカテゴリ
     */
    static func postLocalNotificationIfNeeded(message: String, category: String?) {
        if !shouldNotifyWithCategory(category: category) {
            return
        }
        
        print(message)
        
        let application = UIApplication.shared
        application.cancelAllLocalNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.alertAction = "OPEN"
        notification.category = category
        application.presentLocalNotificationNow(notification)
    }
    
    /**
     通知可否を返す
     
     - parameter category: 通知のカテゴリ
     
     - returns: true:通知可/false:通知不可
     */
    private static func shouldNotifyWithCategory(category: String?) -> Bool {
        guard let category = category else {
            return true
        }
        
        let defaults = UserDefaults.standard
        let key = category
        let now = NSDate()
        let date = defaults.object(forKey: key)
        
        defaults.set(now, forKey: key)
        defaults.synchronize()
        
        if let date = date as? NSDate {
            let remainder = now.timeIntervalSince(date as Date)
            let threshold: TimeInterval = 60.0 * 60.0 * 1.0
            return (remainder > threshold)
        }
        
        return true
    }
}
