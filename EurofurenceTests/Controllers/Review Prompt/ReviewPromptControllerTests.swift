import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

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
    var eventsService: FakeEventsService!
    var controller: ReviewPromptController!
    var versionProviding: StubAppVersionProviding!
    var reviewPromptAppVersionRepository: FakeReviewPromptAppVersionRepository!
    var appStateProviding: FakeAppStateProviding!

    override func setUp() {
        super.setUp()

        config = ReviewPromptController.Config.default
        config.requiredNumberOfFavouriteEvents = Int.random(upperLimit: 5) + 3

        reviewPromptAction = CapturingReviewPromptAction()
        eventsService = FakeEventsService()
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
        let identifiers = (0..<config.requiredNumberOfFavouriteEvents).map({ (_) in EventIdentifier.random })
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
