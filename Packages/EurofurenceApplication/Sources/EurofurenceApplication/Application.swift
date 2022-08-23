import ComponentBase
import DealerComponent
import EurofurenceApplicationSession
import EurofurenceModel
import EventDetailComponent
import Foundation
import UIKit
import URLContent
import UserActivityRouteable

public class Application {
    
    public struct Dependencies {
        
        public let viewEventIntentDonor: EventIntentDonor
        public let viewDealerIntentDonor: ViewDealerIntentDonor
        public let appIcons: AppIconRepository
        
        public init(
            viewEventIntentDonor: EventIntentDonor,
            viewDealerIntentDonor: ViewDealerIntentDonor,
            appIcons: AppIconRepository
        ) {
            self.viewEventIntentDonor = viewEventIntentDonor
            self.viewDealerIntentDonor = viewDealerIntentDonor
            self.appIcons = appIcons
        }
        
    }

    public private(set) static var instance: Application!
    
    private let dependencies: Dependencies
    private let session: EurofurenceSession
    private let backgroundFetcher: BackgroundFetchService
    private let notificationScheduleController: NotificationScheduleController
    private let reviewPromptController: ReviewPromptController
    private let widgetUpdater: EventWidgetUpdater
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
        instance.principalWindowController?.route(EurofurenceNotificationRouteable(userInfo))
    }
    
    public static func resume(activity: NSUserActivity) {
        let routable = EurofurenceUserActivityRouteable(userActivity: activity)
        instance.principalWindowController?.route(routable)
    }
    
    public static func open(URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        let content = EurofurenceURLRouteable(url)
        instance.principalWindowController?.route(content)
    }
    
    private init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        session = EurofurenceSessionBuilder.buildingForEurofurenceApplication()
            .build()
        
        backgroundFetcher = BackgroundFetchService(refreshService: session.services.refresh)
        
        // TODO: Source from preferences/Firebase
        let upcomingEventReminderInterval: TimeInterval = 900
        notificationScheduleController = NotificationScheduleController(
            eventsService: session.repositories.events,
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
            eventsService: session.repositories.events
        )
        
        widgetUpdater = EventWidgetUpdater(
            widgetService: SystemWidgetService(), 
            refreshService: session.services.refresh, 
            eventsService: session.repositories.events
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
