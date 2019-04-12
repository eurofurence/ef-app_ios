import EurofurenceModel
import Foundation

class SharedModel {
    
    private static let CID = ConventionIdentifier(identifier: "EF25")

    static let instance: SharedModel = SharedModel()
    let session: EurofurenceSession
    let services: Services
    let notificationFetchResultAdapter: NotificationServiceFetchResultAdapter
    let notificationScheduleController: NotificationScheduleController

    private init() {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: SharedModel.CID)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                                appVersion: BundleAppVersionProviding.shared,
                                                                                                firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                                fcmRegistration: fcmRegistration)

        let significantTimeChangeAdapter = ApplicationSignificantTimeChangeAdapter()

        let urlOpener = AppURLOpener()

        let longRunningTaskManager = ApplicationLongRunningTaskManager()

        let mapCoordinateRender = UIKitMapCoordinateRender()
        
        session = EurofurenceSessionBuilder(conventionIdentifier: SharedModel.CID)
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
