//
//  ApplicationPushPermissionsRequester.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UserNotifications

struct ApplicationPushPermissionsRequester: PushPermissionsRequester {

    static let shared = ApplicationPushPermissionsRequester()

    private init() {

    }

    func requestPushPermissions(completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, error) in
            if let error = error {
                print("Failed to register for notifications with error: \(error)")
            }

            completionHandler()
        }
    }

}
