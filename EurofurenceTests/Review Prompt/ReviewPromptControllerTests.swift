//
//  ReviewPromptControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
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
    
    override func setUp() {
        super.setUp()
        
        config = ReviewPromptController.Config.default
        config.requiredNumberOfFavouriteEvents = Int.random(upperLimit: 5) + 3
        
        reviewPromptAction = CapturingReviewPromptAction()
        eventsService = FakeEventsService()
        versionProviding = StubAppVersionProviding(version: .random)
        reviewPromptAppVersionRepository = FakeReviewPromptAppVersionRepository()
        controller = ReviewPromptController(config: config,
                                            reviewPromptAction: reviewPromptAction,
                                            versionProviding: versionProviding,
                                            reviewPromptAppVersionRepository: reviewPromptAppVersionRepository,
                                            eventsService: eventsService)
    }
    
    private func simulateFavouritingEvent() {
        eventsService.simulateEventFavourited(identifier: .random)
    }
    
    private func simulateFavouritingEnoughEventsToSatisfyPromptRequirement() {
        let identifiers = (0..<config.requiredNumberOfFavouriteEvents).map({ (_) in Event2.Identifier.random })
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
    
}
