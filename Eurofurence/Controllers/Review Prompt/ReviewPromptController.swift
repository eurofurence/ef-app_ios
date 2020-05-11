import EurofurenceModel
import Foundation

public struct ReviewPromptController: EventsServiceObserver {

    public struct Config {
        public static let `default` = Config(requiredNumberOfFavouriteEvents: 3)

        public var requiredNumberOfFavouriteEvents: Int
    }

    private var config: ReviewPromptController.Config
    private var reviewPromptAction: ReviewPromptAction
    private var eventsService: EventsService
    private var versionProviding: AppVersionProviding
    private var appStateProviding: AppStateProviding
    private var reviewPromptAppVersionRepository: ReviewPromptAppVersionRepository

    public init(
        config: ReviewPromptController.Config,
        reviewPromptAction: ReviewPromptAction,
        versionProviding: AppVersionProviding,
        reviewPromptAppVersionRepository: ReviewPromptAppVersionRepository,
        appStateProviding: AppStateProviding,
        eventsService: EventsService
    ) {
        self.config = config
        self.reviewPromptAction = reviewPromptAction
        self.versionProviding = versionProviding
        self.reviewPromptAppVersionRepository = reviewPromptAppVersionRepository
        self.appStateProviding = appStateProviding
        self.eventsService = eventsService

        eventsService.add(self)
    }

    public func favouriteEventsDidChange(_ identifiers: [EventIdentifier]) {
        let minimumNumberOfEventsFavourited: Bool = identifiers.count >= config.requiredNumberOfFavouriteEvents
        let runningDifferentAppVersionSinceLastPrompt: Bool = versionProviding.version != reviewPromptAppVersionRepository.lastPromptedAppVersion

        if minimumNumberOfEventsFavourited && runningDifferentAppVersionSinceLastPrompt && appStateProviding.isAppActive {
            reviewPromptAction.showReviewPrompt()
            reviewPromptAppVersionRepository.setLastPromptedAppVersion(versionProviding.version)
        }
    }

    public func eventsDidChange(to events: [Event]) { }
    public func runningEventsDidChange(to events: [Event]) { }
    public func upcomingEventsDidChange(to events: [Event]) { }

}
