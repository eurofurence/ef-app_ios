import EurofurenceApplicationSession
import EurofurenceModel
import Foundation
import UIKit

class Application {

    static let instance: Application = Application()
    private let session: EurofurenceSession
    private let backgroundFetcher: BackgroundFetchService
    private let notificationScheduleController: NotificationScheduleController
    private let reviewPromptController: ReviewPromptController
    private var principalWindowController: PrincipalWindowAssembler?
    private let urlOpener = AppURLOpener()
    
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
        instance.principalWindowController?.route(NotificationContentRepresentation(userInfo: userInfo))
    }
    
    static func resume(activity: NSUserActivity) {
        let activityDescription = SystemActivityDescription(userActivity: activity)
        resume(activityDescription: activityDescription)
    }
    
    @available(iOS 13.0, *)
    static func open(URLContexts: Set<UIOpenURLContext>) {
        let activityDescription = URLContextActivityDescription(URLContexts: URLContexts)
        resume(activityDescription: activityDescription)
    }
    
    private static func resume(activityDescription: ActivityDescription) {
        let contentRepresentation = UserActivityContentRepresentation(activity: activityDescription)
        instance.principalWindowController?.route(contentRepresentation)
    }
    
    private init() {
        session = EurofurenceSessionBuilder.buildingForEurofurenceApplication()
            .with(ApplicationSignificantTimeChangeAdapter())
            .with(urlOpener)
            .with(ApplicationLongRunningTaskManager())
            .with(UIKitMapCoordinateRender())
            .build()
        
        backgroundFetcher = BackgroundFetchService(refreshService: session.services.refresh)
        
        // TODO: Source from preferences/Firebase
        let upcomingEventReminderInterval: TimeInterval = 900
        notificationScheduleController = NotificationScheduleController(
            eventsService: session.services.events,
            notificationScheduler: UserNotificationsScheduler(),
            hoursDateFormatter: FoundationHoursDateFormatter.shared,
            upcomingEventReminderInterval: upcomingEventReminderInterval,
            clock: SystemClock.shared
        )
        
        reviewPromptController = ReviewPromptController(
            config: .default,
            reviewPromptAction: StoreKitReviewPromptAction(),
            versionProviding: BundleAppVersionProviding.shared,
            reviewPromptAppVersionRepository: UserDefaultsReviewPromptAppVersionRepository(),
            appStateProviding: ApplicationAppStateProviding(),
            eventsService: session.services.events
        )
        
        _ = EventWidgetUpdater(widgetService: SystemWidgetService(), refreshService: session.services.refresh)
    }
    
    func configurePrincipalScene(window: UIWindow) {
        principalWindowController = PrincipalWindowAssembler(
            window: window,
            services: session.services,
            repositories: session.repositories,
            urlOpener: urlOpener
        )
    }

}
