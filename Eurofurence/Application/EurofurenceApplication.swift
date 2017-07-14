//
//  EurofurenceApplication.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 14/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

struct EurofurenceApplication {

    private var buildConfiguration: BuildConfigurationProviding
    private var notificationsService: NotificationsService

    init(buildConfiguration: BuildConfigurationProviding,
         notificationsService: NotificationsService) {
        self.buildConfiguration = buildConfiguration
        self.notificationsService = notificationsService
    }

    func handleRemoteNotificationRegistration(deviceToken: Data) {
        notificationsService.register(deviceToken: deviceToken)

        switch buildConfiguration.configuration {
        case .debug:
            notificationsService.subscribeToTestNotifications()
            notificationsService.unsubscribeFromLiveNotifications()
        case .release:
            notificationsService.subscribeToLiveNotifications()
            notificationsService.unsubscribeFromTestNotifications()
        }
    }

}
