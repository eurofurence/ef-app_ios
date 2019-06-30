import EurofurenceModel
import Foundation
import UIKit

class ApplicationStack {
    
    private static let CID = ConventionIdentifier(identifier: "EF25")

    static let instance: ApplicationStack = ApplicationStack()
    private let director: ApplicationDirector
    let session: EurofurenceSession
    let services: Services
    private let notificationFetchResultAdapter: NotificationServiceFetchResultAdapter
    let notificationScheduleController: NotificationScheduleController
    private let notificationResponseProcessor: NotificationResponseProcessor
    private let activityResumer: ActivityResumer
    
    static func assemble() {
        _ = instance
    }
    
    static func storeRemoteNotificationsToken(_ deviceToken: Data) {
        instance.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }
    
    static func handleRemoteNotification(_ payload: [AnyHashable: Any],
                                         completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        instance.notificationFetchResultAdapter.handleRemoteNotification(payload, completionHandler: completionHandler)
    }
    
    static func openNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        instance.notificationResponseProcessor.openNotification(userInfo, completionHandler: completionHandler)
    }
    
    static func resume(activity: NSUserActivity) -> Bool {
        let activityDescription = SystemActivityDescription(userActivity: activity)
        return instance.activityResumer.resume(activity: activityDescription)
    }

    private init() {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: ApplicationStack.CID)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                                appVersion: BundleAppVersionProviding.shared,
                                                                                                conventionIdentifier: ApplicationStack.CID,
                                                                                                firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                                fcmRegistration: fcmRegistration)
        
        let remoteConfigurationLoader = FirebaseRemoteConfigurationLoader()
        let conventionStartDateRepository = RemotelyConfiguredConventionStartDateRepository(remoteConfigurationLoader: remoteConfigurationLoader)

        let significantTimeChangeAdapter = ApplicationSignificantTimeChangeAdapter()

        let urlOpener = AppURLOpener()

        let longRunningTaskManager = ApplicationLongRunningTaskManager()

        let mapCoordinateRender = UIKitMapCoordinateRender()
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: ApplicationStack.CID,
            conventionStartDateRepository: conventionStartDateRepository
        )
        
        session = EurofurenceSessionBuilder(mandatory: mandatory)
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
        
        director = DirectorBuilder(moduleRepository: ApplicationModuleRepository(services: services, repositories: session.repositories),
                                   linkLookupService: services.contentLinks).build()
        services.contentLinks.setExternalContentHandler(director)
        
        let notificationHandler = NavigateToContentNotificationResponseHandler(director: director)
        notificationResponseProcessor = NotificationResponseProcessor(notificationHandling: services.notifications,
                                                                      contentRecipient: notificationHandler)
        
        let resumeInteractionResponseHandler = DirectorContentRouter(director: director)
        activityResumer = ActivityResumer(resumeResponseHandler: resumeInteractionResponseHandler)
    }

}
