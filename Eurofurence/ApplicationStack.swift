import EurofurenceModel
import Foundation
import UIKit

class WindowContentWireframe: ContentWireframe {
    
    static var shared: WindowContentWireframe = {
        guard let window = UIApplication.shared.delegate?.window, let unwrappedWindow = window else { fatalError("Application has no window") }
        return WindowContentWireframe(window: unwrappedWindow)
    }()
    
    private let window: UIWindow
    
    private init(window: UIWindow) {
        self.window = window
    }
    
    func presentMasterContentController(_ viewController: UIViewController) {
        window.rootViewController?.show(viewController, sender: nil)
    }
    
    func presentDetailContentController(_ viewController: UIViewController) {
        window.rootViewController?.showDetailViewController(viewController, sender: nil)
    }
    
}

class WindowModalWireframe: ModalWireframe {
    
    static var shared: WindowModalWireframe = {
        guard let window = UIApplication.shared.delegate?.window, let unwrappedWindow = window else { fatalError("Application has no window") }
        return WindowModalWireframe(window: unwrappedWindow)
    }()
    
    private let window: UIWindow
    
    private init(window: UIWindow) {
        self.window = window
    }
    
    func presentModalContentController(_ viewController: UIViewController, completion: (() -> Void)?) {
        window.rootViewController?.present(viewController, animated: true, completion: completion)
    }
    
}

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
        
        session = EurofurenceSessionBuilder(mandatory: mandatory)
            .with(remoteNotificationsTokenRegistration)
            .with(ApplicationSignificantTimeChangeAdapter())
            .with(AppURLOpener())
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
        
        let contentWireframe = WindowContentWireframe.shared
        let modalWireframe = WindowModalWireframe.shared
        let router = MutableContentRouter()
        
        let moduleRepository = ApplicationModuleRepository(services: services, repositories: session.repositories)
        let newsSubrouter = NewsSubrouter(router: router)
        
        director = DirectorBuilder(moduleRepository: moduleRepository, linkLookupService: services.contentLinks)
            .with(newsSubrouter)
            .build()
        
        let notificationHandler = NavigateToContentNotificationResponseHandler(director: director)
        notificationResponseProcessor = NotificationResponseProcessor(notificationHandling: services.notifications,
                                                                      contentRecipient: notificationHandler)
        
        let directorContentRouter = DirectorContentRouter(director: director)
        activityResumer = ActivityResumer(contentLinksService: services.contentLinks, contentRouter: directorContentRouter)
        
        RouterConfigurator(
            router: router,
            contentWireframe: contentWireframe,
            modalWireframe: modalWireframe,
            moduleRepository: moduleRepository,
            services: services
        ).configureRoutes()
    }
    
    struct RouterConfigurator {
        
        var router: MutableContentRouter
        var contentWireframe: ContentWireframe
        var modalWireframe: ModalWireframe
        var moduleRepository: ApplicationModuleRepository
        var services: Services
        
        func configureRoutes() {
            configureAnnouncementsRoute()
            configureAnnouncementRoute()
            configureDealerRoute()
            configureEventRoute()
            configureMessageRoute()
            configureMessagesRoute()
            configureLoginRoute()
        }
        
        private func configureAnnouncementsRoute() {
            router.add(AnnouncementsContentRoute(
                announcementsModuleProviding: moduleRepository.announcementsModuleFactory,
                contentWireframe: contentWireframe,
                delegate: NavigateFromAnnouncementsToAnnouncement(router: router)
            ))
        }
        
        private func configureAnnouncementRoute() {
            router.add(AnnouncementContentRoute(
                announcementModuleFactory: moduleRepository.announcementDetailModuleProviding,
                contentWireframe: contentWireframe
            ))
        }
        
        private func configureDealerRoute() {
            router.add(DealerContentRoute(
                dealerModuleFactory: moduleRepository.dealerDetailModuleProviding,
                contentWireframe: contentWireframe
            ))
        }
        
        private func configureEventRoute() {
            struct DummyEventDetailModuleDelegate: EventDetailModuleDelegate {
                
                func eventDetailModuleDidRequestPresentationToLeaveFeedback(for event: EventIdentifier) {
                    
                }
                
            }
            
            router.add(EventContentRoute(
                eventModuleFactory: moduleRepository.eventDetailModuleProviding,
                eventDetailDelegate: DummyEventDetailModuleDelegate(),
                contentWireframe: contentWireframe
            ))
        }
        
        private func configureMessageRoute() {
            router.add(MessageContentRoute(
                messageModuleFactory: moduleRepository.messageDetailModuleProviding,
                contentWireframe: contentWireframe
            ))
        }
        
        private func configureMessagesRoute() {
            router.add(MessagesContentRoute(
                router: router,
                messagesModuleProviding: moduleRepository.messagesModuleProviding,
                contentWireframe: contentWireframe,
                authenticationService: services.authentication,
                delegate: NavigateFromMessagesToMessage(
                    router: router,
                    modalWireframe: modalWireframe
                )
            ))
        }
        
        private func configureLoginRoute() {
            let formSheetWrapper = FormSheetLoginModuleProviding(
                loginModuleProviding: moduleRepository.loginModuleProviding
            )
            
            router.add(LoginContentRoute(
                loginModuleFactory: formSheetWrapper,
                modalWireframe: modalWireframe
            ))
        }
        
    }

}
