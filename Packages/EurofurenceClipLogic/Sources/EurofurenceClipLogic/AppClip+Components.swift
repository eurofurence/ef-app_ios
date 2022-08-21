import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceModel
import EventDetailComponent
import PreloadComponent
import ScheduleComponent
import TutorialComponent
import UIKit

extension AppClip {
    
    struct Components {
        
        let tutorialComponent: TutorialComponentFactory
        let preloadComponent: PreloadComponentFactory
        let scheduleComponentFactory: ScheduleComponentFactory
        let eventDetailComponentFactory: EventDetailComponentFactory
        let dealersComponentFactory: DealersComponentFactory
        let dealerDetailModuleProviding: DealerDetailComponentFactory
        
        // swiftlint:disable function_body_length
        init(
            window: UIWindow,
            dependencies: AppClip.Dependencies,
            repositories: Repositories,
            services: Services
        ) {
            let alertRouter = WindowAlertRouter(window: window)
            let shareService = ActivityShareService(window: window)
            let activityFactory = PlatformActivityFactory()
            
            tutorialComponent = TutorialModuleBuilder(alertRouter: alertRouter).build()
            
            let preloadInteractor = ApplicationPreloadInteractor(refreshService: services.refresh)
            preloadComponent = PreloadComponentBuilder(
                preloadInteractor: preloadInteractor,
                alertRouter: alertRouter
            ).build()
            
            let scheduleViewModelFactory = DefaultScheduleViewModelFactory(
                eventsService: repositories.events,
                hoursDateFormatter: FoundationHoursDateFormatter.shared,
                shortFormDateFormatter: FoundationShortFormDateFormatter.shared,
                shortFormDayAndTimeFormatter: FoundationShortFormDayAndTimeFormatter.shared,
                refreshService: services.refresh,
                shareService: shareService
            )
            
            scheduleComponentFactory = ScheduleModuleBuilder(
                scheduleViewModelFactory: scheduleViewModelFactory
            ).build()
            
            let eventInteractionRecorder = SystemEventInteractionsRecorder(
                eventsService: repositories.events,
                eventIntentDonor: dependencies.eventIntentDonor,
                activityFactory: activityFactory
            )
            
            let eventDetailViewModelFactory = DefaultEventDetailViewModelFactory(
                dateRangeFormatter: FoundationDateRangeFormatter.shared,
                eventsService: repositories.events,
                markdownRenderer: DefaultDownMarkdownRenderer(),
                shareService: shareService,
                calendarRepository: EventKitCalendarEventRepository()
            )
            
            eventDetailComponentFactory = EventDetailComponentBuilder(
                eventDetailViewModelFactory: eventDetailViewModelFactory,
                interactionRecorder: eventInteractionRecorder
            ).build()
            
            let dealersViewModelFactory = DefaultDealersViewModelFactory(
                dealersService: services.dealers,
                refreshService: services.refresh
            )
            
            dealersComponentFactory = DealersComponentBuilder(
                dealersViewModelFactory: dealersViewModelFactory
            ).build()
            
            let dealerInteractionRecorder = DonateIntentDealerInteractionRecorder(
                viewDealerIntentDonor: dependencies.dealerIntentDonor,
                dealersService: services.dealers,
                activityFactory: activityFactory
            )
            
            let dealerDetailViewModelFactory = DefaultDealerDetailViewModelFactory(
                dealersService: services.dealers,
                shareService: shareService
            )

            dealerDetailModuleProviding = DealerDetailComponentBuilder(
                dealerDetailViewModelFactory: dealerDetailViewModelFactory,
                dealerInteractionRecorder: dealerInteractionRecorder
            ).build()
        }
        
    }
    
}
