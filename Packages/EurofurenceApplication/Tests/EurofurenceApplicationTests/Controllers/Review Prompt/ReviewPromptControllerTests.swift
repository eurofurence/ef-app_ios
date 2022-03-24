import EurofurenceApplication
import EurofurenceModel
import XCTest
import XCTEurofurenceModel

extension CountableRange {

    func forEachPerform(_ closure: @escaping () throws -> Void) rethrows {
        try forEach { (_) in
            try closure()
        }
    }

}

class ReviewPromptControllerTests: XCTestCase {

    var reviewPromptAction: CapturingReviewPromptAction!
    var config: ReviewPromptController.Config!
    var eventsService: FakeScheduleRepository!
    var controller: ReviewPromptController!
    var versionProviding: StubAppVersionProviding!
    var reviewPromptAppVersionRepository: FakeReviewPromptAppVersionRepository!
    var appStateProviding: FakeAppStateProviding!

    override func setUp() {
        super.setUp()
        
        let events: [FakeEvent] = [.random, .random, .random]
        eventsService = FakeScheduleRepository()
        eventsService.allEvents = events

        config = ReviewPromptController.Config.default
        config.requiredNumberOfFavouriteEvents = eventsService.allEvents.count

        reviewPromptAction = CapturingReviewPromptAction()
        versionProviding = StubAppVersionProviding(version: .random)
        reviewPromptAppVersionRepository = FakeReviewPromptAppVersionRepository()
        appStateProviding = FakeAppStateProviding()
        controller = ReviewPromptController(config: config,
                                            reviewPromptAction: reviewPromptAction,
                                            versionProviding: versionProviding,
                                            reviewPromptAppVersionRepository: reviewPromptAppVersionRepository,
                                            appStateProviding: appStateProviding,
                                            eventsService: eventsService)
    }

    private func simulateFavouritingEvent() {
        eventsService.simulateEventFavourited(identifier: .random)
    }

    private func simulateFavouritingEnoughEventsToSatisfyPromptRequirement() {
        let eventsToFavourite = eventsService.allEvents.prefix(config.requiredNumberOfFavouriteEvents)
        let identifiers = eventsToFavourite.map(\.identifier)
        eventsService.simulateEventFavouritesChanged(to: identifiers)
    }

    func testShowTheReviewPromptWhenRequiredNumberOfEventsFavourited() {
        simulateFavouritingEnoughEventsToSatisfyPromptRequirement()
        XCTAssertTrue(reviewPromptAction.didShowReviewPrompt)
    }

    func testNotShowTheReviewPromptBeforeTheConfiguredFavouriteCount() {
        (0..<config.requiredNumberOfFavouriteEvents - 1).forEachPerform(simulateFavouritingEvent)
        XCTAssertFalse(reviewPromptAction.didShowReviewPrompt)
    }

    func testNotShowTheReviewPromptWhenFavouritingRequiredEventCountAgainForSameAppVersion() {
        simulateFavouritingEnoughEventsToSatisfyPromptRequirement()
        reviewPromptAction.reset()
        simulateFavouritingEvent()

        XCTAssertFalse(reviewPromptAction.didShowReviewPrompt)
    }

    func testNotShowTheReviewPromptWhileTheAppIsLaunching() {
        appStateProviding.isAppActive = false
        simulateFavouritingEnoughEventsToSatisfyPromptRequirement()

        XCTAssertFalse(reviewPromptAction.didShowReviewPrompt)
    }

}
