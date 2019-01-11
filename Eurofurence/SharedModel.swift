//
//  SharedModel.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 27/12/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class SharedModel {

    static let instance: SharedModel = SharedModel()
    let session: EurofurenceSession
    let services: Services
    let notificationFetchResultAdapter: NotificationServiceFetchResultAdapter

    private init() {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        let apiUrl = BuildConfigurationAPIURLProviding(buildConfiguration)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                                appVersion: BundleAppVersionProviding.shared,
                                                                                                firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                                fcmRegistration: fcmRegistration)

        let pushPermissionsRequester = ApplicationPushPermissionsRequester.shared

        let significantTimeChangeAdapter = ApplicationSignificantTimeChangeAdapter()

        let urlOpener = AppURLOpener()

        let longRunningTaskManager = ApplicationLongRunningTaskManager()

        let notificationsService = UserNotificationsScheduler()

        let mapCoordinateRender = UIKitMapCoordinateRender()

        session = EurofurenceSessionBuilder()
            .with(remoteNotificationsTokenRegistration)
            .with(pushPermissionsRequester)
            .with(significantTimeChangeAdapter)
            .with(urlOpener)
            .with(longRunningTaskManager)
            .with(notificationsService)
            .with(mapCoordinateRender)
            .build()

        services = session.services

        notificationFetchResultAdapter = NotificationServiceFetchResultAdapter(notificationService: services.notifications)
    }

}
