//
//  ApplicationPushPermissionsRequester.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/09/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

struct ApplicationPushPermissionsRequester: PushPermissionsRequester {

    func requestPushPermissions() {
        let application = UIApplication.shared
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }

}
