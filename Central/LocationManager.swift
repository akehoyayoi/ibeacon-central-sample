//
//  LocationManager.swift
//  Central
//
//  Created by YOHEI OKAYA on 2019/05/20.
//  Copyright © 2019 YOHEI OKAYA. All rights reserved.
//

import CoreLocation

class LocationManager: CLLocationManager {
    private static let sharedInstance = LocationManager()
    
    /**
     位置情報取得の許可を確認
     */
    static func requestAlwaysAuthorization() {
        // バックグラウンドでも位置情報更新をチェックする
        sharedInstance.allowsBackgroundLocationUpdates = true
        sharedInstance.delegate = sharedInstance
        sharedInstance.requestAlwaysAuthorization()
    }
}

// MARK: CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Start monitoring for region")
        manager.requestState(for: region)
    }
    
    private func locationManager(manager: CLLocationManager,
                                 didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                let uuid: NSUUID? = NSUUID(uuidString: "48534442-4C45-4144-80C0-1800FFFFFFF2")
                let beaconID: String = "jp.co.houwa-js.test.blog"
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: beaconID)
                beaconRegion.notifyEntryStateOnDisplay = true   // ディスプレイ表示中も通知する
                manager.startMonitoring(for: beaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState,
                         for region: CLRegion) {
        if state == .inside {
            NotificationManager.postLocalNotificationIfNeeded(
                message: "出勤しますか？",
                category: NotificationManager.workCategoryIdentifier)
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didEnterRegion region: CLRegion) {
        NotificationManager.postLocalNotificationIfNeeded(
            message: "出勤しますか？",
            category: NotificationManager.workCategoryIdentifier)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didExitRegion region: CLRegion) {
        NotificationManager.postLocalNotificationIfNeeded(
            message: "退勤しますか？",
            category: NotificationManager.homeCategoryIdentifier)
    }
}

