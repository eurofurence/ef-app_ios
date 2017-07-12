//
//  ApplicationPushPermissionsRequesting.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 12/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import UIKit

// TODO: Work out how to keep this behaviour long term w/ tests
// We have to deal with the callback from the app delegate so it still needs
// to poke something, however that should ideally be the Eurofurence core instead
// of the presentation tier. Leaving this untested so we can move fast for now.
class ApplicationPushPermissionsRequesting: PushPermissionsRequesting {

    private var completionHandler: (() -> Void)?

    func requestPushPermissions(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
        let application = UIApplication.shared
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
    }

    func handlePushRegistrationSuccess() {
        completionHandler?()
    }

    func handlePushRegistrationFailure() {
        completionHandler?()
    }

}
