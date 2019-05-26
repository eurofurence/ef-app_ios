import EurofurenceModel
import Foundation
import UIKit

class ApplicationStack {
    
    private static let CID = ConventionIdentifier(identifier: "EF25")

    static let instance: ApplicationStack = ApplicationStack()
    let session: EurofurenceSession
    let services: Services
    private let notificationFetchResultAdapter: NotificationServiceFetchResultAdapter
    let notificationScheduleController: NotificationScheduleController
    
    static func storeRemoteNotificationsToken(_ deviceToken: Data) {
        instance.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }
    
    static func handleRemoteNotification(_ payload: [AnyHashable: Any],
                                         completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        instance.notificationFetchResultAdapter.handleRemoteNotification(payload, completionHandler: completionHandler)
    }

    private init() {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: ApplicationStack.CID)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                                appVersion: BundleAppVersionProviding.shared,
                                                                                                firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                                fcmRegistration: fcmRegistration)

        let significantTimeChangeAdapter = ApplicationSignificantTimeChangeAdapter()

        let urlOpener = AppURLOpener()

        let longRunningTaskManager = ApplicationLongRunningTaskManager()

        let mapCoordinateRender = UIKitMapCoordinateRender()
        
        session = EurofurenceSessionBuilder(conventionIdentifier: ApplicationStack.CID)
            .with(remoteNotificationsTokenRegistration)
            .with(significantTimeChangeAdapter)
            .with(urlOpener)
            .with(longRunningTaskManager)
            .with(mapCoordinateRender)
            .build()

        services = session.services

        notificationFetchResultAdapter = NotificationServiceFetchResultAdapter(notificationService: services.notifications)
        
        // TODO: Source from preferences/Firebase
        let upcomingEventReminderInterval: TimeInterval = 900
        notificationScheduleController = NotificationScheduleController(eventsService: session.services.events,
                                                                        notificationScheduler: UserNotificationsScheduler(),
                                                                        hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                                        upcomingEventReminderInterval: upcomingEventReminderInterval)
    }

}
