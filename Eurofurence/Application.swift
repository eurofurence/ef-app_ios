import EurofurenceModel
import Foundation
import UIKit

class Application {
    
    private static let CID = ConventionIdentifier(identifier: "EF25")

    static let instance: Application = Application()
    private let session: EurofurenceSession
    private let backgroundFetcher: BackgroundFetchService
    private let notificationScheduleController: NotificationScheduleController
    private let reviewPromptController: ReviewPromptController
    private let principalWindowController: PrincipalWindowController
    
    static func assemble() {
        _ = instance
    }
    
    static func storeRemoteNotificationsToken(_ deviceToken: Data) {
        instance.session.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }
    
    static func executeBackgroundFetch(
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        instance.backgroundFetcher.executeFetch(completionHandler: completionHandler)
    }
    
    static func openNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        instance.principalWindowController.route(NotificationContentRepresentation(userInfo: userInfo))
    }
    
    static func resume(activity: NSUserActivity) {
        let activityDescription = SystemActivityDescription(userActivity: activity)
        let contentRepresentation = UserActivityContentRepresentation(activity: activityDescription)
        instance.principalWindowController.route(contentRepresentation)
    }

    private init() {
        let jsonSession = URLSessionBasedJSONSession.shared
        let buildConfiguration = PreprocessorBuildConfigurationProviding()
        
        let apiUrl = CIDAPIURLProviding(conventionIdentifier: Application.CID)
        let fcmRegistration = EurofurenceFCMDeviceRegistration(JSONSession: jsonSession, urlProviding: apiUrl)
        let remoteNotificationsTokenRegistration = FirebaseRemoteNotificationsTokenRegistration(buildConfiguration: buildConfiguration,
                                                                                                appVersion: BundleAppVersionProviding.shared,
                                                                                                conventionIdentifier: Application.CID,
                                                                                                firebaseAdapter: FirebaseMessagingAdapter(),
                                                                                                fcmRegistration: fcmRegistration)
        
        let remoteConfigurationLoader = FirebaseRemoteConfigurationLoader()
        let conventionStartDateRepository = RemotelyConfiguredConventionStartDateRepository(remoteConfigurationLoader: remoteConfigurationLoader)
        
        let mandatory = EurofurenceSessionBuilder.Mandatory(
            conventionIdentifier: Application.CID,
            conventionStartDateRepository: conventionStartDateRepository,
            shareableURLFactory: CIDBasedShareableURLFactory(conventionIdentifier: Application.CID)
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
        
        backgroundFetcher = BackgroundFetchService(refreshService: session.services.refresh)
        
        // TODO: Source from preferences/Firebase
        let upcomingEventReminderInterval: TimeInterval = 900
        notificationScheduleController = NotificationScheduleController(eventsService: session.services.events,
                                                                        notificationScheduler: UserNotificationsScheduler(),
                                                                        hoursDateFormatter: FoundationHoursDateFormatter.shared,
                                                                        upcomingEventReminderInterval: upcomingEventReminderInterval)
        
        reviewPromptController = ReviewPromptController(
            config: .default,
            reviewPromptAction: StoreKitReviewPromptAction(),
            versionProviding: BundleAppVersionProviding.shared,
            reviewPromptAppVersionRepository: UserDefaultsReviewPromptAppVersionRepository(),
            appStateProviding: ApplicationAppStateProviding(),
            eventsService: session.services.events
        )
        
        guard let appWindow = UIApplication.shared.delegate?.window,
              let window = appWindow else { fatalError() }
        
        principalWindowController = PrincipalWindowController(
            window: window,
            services: session.services,
            repositories: session.repositories,
            urlOpener: urlOpener
        )
    }

}

struct PrincipalWindowController {
    
    private let router: ContentRouter
    
    func route<T>(_ content: T) where T: ContentRepresentation {
        try? router.route(content)
    }
    
    init(
        window: UIWindow,
        services: Services,
        repositories: Repositories,
        urlOpener: URLOpener
    ) {
        let router = MutableContentRouter()
        self.router = router
        
        let moduleRepository = ApplicationModuleRepository(services: services, repositories: repositories)
        let newsSubrouter = NewsSubrouter(router: router)
        let scheduleSubrouter = ShowEventFromSchedule(router: router)
        let dealerSubrouter = ShowDealerFromDealers(router: router)
        let knowledgeSubrouter = ShowKnowledgeContentFromListing(router: router)
        let mapSubrouter = ShowMapFromMaps(router: router)
        
        let routeAuthenticationHandler = AuthenticateOnDemandRouteAuthenticationHandler(
            service: services.authentication,
            router: router
        )
        
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
        
        let newsContentControllerFactory = NewsContentControllerFactory(
            newsModuleProviding: moduleRepository.newsModuleProviding,
            newsModuleDelegate: newsSubrouter
        )
        
        let scheduleContentControllerFactory = ScheduleContentControllerFactory(
            scheduleModuleProviding: moduleRepository.scheduleModuleProviding,
            scheduleModuleDelegate: scheduleSubrouter
        )
        
        let dealersContentControllerFactory = DealersContentControllerFactory(
            dealersModuleProviding: moduleRepository.dealersModuleProviding,
            dealersModuleDelegate: dealerSubrouter
        )
        
        let knowledgeContentControllerFactory = KnowledgeContentControllerFactory(
            knowledgeModuleProviding: moduleRepository.knowledgeListModuleProviding,
            knowledgeModuleDelegate: knowledgeSubrouter
        )
        
        let mapsContentControllerFactory = MapsContentControllerFactory(
            mapsModuleProviding: moduleRepository.mapsModuleProviding,
            mapsModuleDelegate: mapSubrouter
        )
        
        let collectThemAllContentControllerFactory = CollectThemAllContentControllerFactory(
            collectThemAllModuleProviding: moduleRepository.collectThemAllModuleProviding
        )
        
        let additionalServicesContentControllerFactory = AdditionalServicesContentControllerFactory(
            additionalServicesModuleProviding: moduleRepository.additionalServicesModuleProviding
        )
        
        let moreContentControllerFactory = MoreContentControllerFactory(supplementaryContentControllerFactories: [
            mapsContentControllerFactory,
            collectThemAllContentControllerFactory,
            additionalServicesContentControllerFactory
        ])
        
        let contentControllerFactories: [ContentControllerFactory] = [
            newsContentControllerFactory,
            scheduleContentControllerFactory,
            dealersContentControllerFactory,
            knowledgeContentControllerFactory,
            moreContentControllerFactory
        ]
        
        let principalWindowScene = ModuleSwappingPrincipalWindowScene(
            windowWireframe: AppWindowWireframe.shared,
            tutorialModule: moduleRepository.tutorialModuleProviding,
            preloadModule: moduleRepository.preloadModuleProviding,
            principalContentModule: PrincipalContentAggregator(contentControllerFactories: contentControllerFactories)
        )
        
        _ = PrincipalWindowSceneController(sessionState: services.sessionState, scene: principalWindowScene)
    }
    
}
