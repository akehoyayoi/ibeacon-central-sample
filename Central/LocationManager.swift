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
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                let uuid: NSUUID? = NSUUID(uuidString: "01122334-4556-6778-899A-ABBCCDDEEFF0")
                let beaconID: String = "com.akehoyayoi.beacon.trial"
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: beaconID)
                beaconRegion.notifyEntryStateOnDisplay = true   // ディスプレイ表示中も通知する
                manager.startMonitoring(for: beaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didDetermineState state: CLRegionState,
                         for region: CLRegion) {

        let uuid: NSUUID? = NSUUID(uuidString: "01122334-4556-6778-899A-ABBCCDDEEFF0")
        let beaconID: String = "com.akehoyayoi.beacon.trial"
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid! as UUID, identifier: beaconID)
        beaconRegion.notifyEntryStateOnDisplay = true   // ディスプレイ表示中も通知する
        manager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                         in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            print(beacon)
            // TODO : 優先度低　通信してUUIDから情報を取得する処理を入れる
            
            // TODO : 優先度高　通知すべき状態になったタイミングで通知を送る
            print(beacon.major)
            print(beacon.minor)
        }
    }
}

