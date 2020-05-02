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
                                         completionHandler: @escaping (UIBackgroundFetchResult) -> Void = { (_) in }) {
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
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: ApplicationStack.CID,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: CIDBasedShareableURLFactory(conventionIdentifier: ApplicationStack.CID)
        )
        
        let urlOpener = AppURLOpener()
        session = EurofurenceSessionBuilder(mandatory: mandatory)
            .with(remoteNotificationsTokenRegistration)
            .with(ApplicationSignificantTimeChangeAdapter())
            .with(urlOpener)
            .with(ApplicationLongRunningTaskManager())
            .with(UIKitMapCoordinateRender())
            .with(UpdateRemoteConfigRefreshCollaboration(remoteConfigurationLoader: remoteConfigurationLoader))
            .build()

        services = session.services

        notificationFetchResultAdapter = NotificationServiceFetchResultAdapter(notificationService: services.notifications)
        
        // TODO: Source from preferences/Firebase
        let upcomingEventReminderInterval: TimeInterval = 900
        notificationScheduleController = NotificationScheduleController(eventsService: session.services.events,
                                                                        notificationScheduler: UserNotificationsScheduler(),
                                                                        hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                                        upcomingEventReminderInterval: upcomingEventReminderInterval)
        
        let router = MutableContentRouter()
        
        let moduleRepository = ApplicationModuleRepository(services: services, repositories: session.repositories)
        let newsSubrouter = NewsSubrouter(router: router)
        let scheduleSubrouter = ShowEventFromSchedule(router: router)
        let dealerSubrouter = ShowDealerFromDealers(router: router)
        let knowledgeSubrouter = ShowKnowledgeContentFromListing(router: router)
        let mapSubrouter = ShowMapFromMaps(router: router)
        
        director = DirectorBuilder(moduleRepository: moduleRepository, linkLookupService: services.contentLinks)
            .with(newsSubrouter)
            .with(scheduleSubrouter)
            .with(dealerSubrouter)
            .with(knowledgeSubrouter)
            .with(mapSubrouter)
            .build()
        
        let notificationHandler = NavigateToContentNotificationResponseHandler(director: director)
        notificationResponseProcessor = NotificationResponseProcessor(notificationHandling: services.notifications,
                                                                      contentRecipient: notificationHandler)
        
        let directorContentRouter = DirectorContentRouter(director: director)
        activityResumer = ActivityResumer(contentLinksService: services.contentLinks, contentRouter: directorContentRouter)
        
        let routeAuthenticationHandler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: services.authentication,
            router: router
        )
        
        guard let appWindow = UIApplication.shared.delegate?.window,
              let window = appWindow else { fatalError() }
        
        let contentWireframe = WindowContentWireframe(window: window)
        let modalWireframe = WindowModalWireframe(window: window)
        
        RouterConfigurator(
            router: router,
            contentWireframe: contentWireframe,
            modalWireframe: modalWireframe,
            moduleRepository: moduleRepository,
            routeAuthenticationHandler: routeAuthenticationHandler,
            linksService: services.contentLinks,
            urlOpener: urlOpener,
            window: window
        ).configureRoutes()
    }

}
