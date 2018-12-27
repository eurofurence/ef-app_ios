//
//  ApplicationPushPermissionsRequester.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import EurofurenceModel
import UserNotifications
import UIKit

struct ApplicationPushPermissionsRequester: PushPermissionsRequester {

    static let shared = ApplicationPushPermissionsRequester()

    private init() {

    }

    func requestPushPermissions() {
        UIApplication.shared.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, error) in
            if let error = error {
                print("Failed to register for notifications with error: \(error)")
            }
        }
    }

}
