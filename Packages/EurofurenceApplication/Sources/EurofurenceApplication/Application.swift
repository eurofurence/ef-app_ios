import ComponentBase
import DealerComponent
import EurofurenceApplicationSession
import EurofurenceModel
import EventDetailComponent
import Foundation
import UIKit

public class Application {
    
    public struct Dependencies {
        
        public let viewEventIntentDonor: EventIntentDonor?
        public let viewDealerIntentDonor: ViewDealerIntentDonor?
        
        public init(viewEventIntentDonor: EventIntentDonor?, viewDealerIntentDonor: ViewDealerIntentDonor?) {
            self.viewEventIntentDonor = viewEventIntentDonor
            self.viewDealerIntentDonor = viewDealerIntentDonor
        }
        
    }

    public private(set) static var instance: Application!
    
    private let dependencies: Dependencies
    private let session: EurofurenceSession
    private let backgroundFetcher: BackgroundFetchService
    private let notificationScheduleController: NotificationScheduleController
    private let reviewPromptController: ReviewPromptController
    private var principalWindowController: PrincipalWindowAssembler?
    
    public static func assemble(dependencies: Dependencies) {
        instance = Application(dependencies: dependencies)
    }
    
    public static func storeRemoteNotificationsToken(_ deviceToken: Data) {
        instance.session.services.notifications.storeRemoteNotificationsToken(deviceToken)
    }
    
    public static func executeBackgroundFetch(
        completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        instance.backgroundFetcher.executeFetch(completionHandler: completionHandler)
    }
    
    public static func openNotification(_ userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        instance.principalWindowController?.route(NotificationContentRepresentation(userInfo: userInfo))
    }
    
    public static func resume(activity: NSUserActivity) {
        let activityDescription = SystemActivityDescription(userActivity: activity)
        resume(activityDescription: activityDescription)
    }
    
    @available(iOS 13.0, *)
    public static func open(URLContexts: Set<UIOpenURLContext>) {
        let activityDescription = URLContextActivityDescription(URLContexts: URLContexts)
        resume(activityDescription: activityDescription)
    }
    
    private static func resume(activityDescription: ActivityDescription) {
        let contentRepresentation = UserActivityContentRepresentation(activity: activityDescription)
        instance.principalWindowController?.route(contentRepresentation)
    }
    
    private init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        session = EurofurenceSessionBuilder.buildingForEurofurenceApplication()
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
        
        _ = EventWidgetUpdater(
            widgetService: SystemWidgetService(), 
            refreshService: session.services.refresh, 
            eventsService: session.services.events
        )
    }
    
    public func configurePrincipalScene(window: UIWindow) {
        principalWindowController = PrincipalWindowAssembler(
            dependencies: dependencies,
            window: window,
            services: session.services,
            repositories: session.repositories,
            urlOpener: AppURLOpener.shared
        )
    }

}
