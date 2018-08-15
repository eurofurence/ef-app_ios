//
//  ReviewPromptControllerTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ReviewPromptControllerTests: XCTestCase {
    
    func testShowTheReviewPromptWhenThirdEventFavourited() {
        let reviewPromptAction = CapturingReviewPromptAction()
        let eventsService = FakeEventsService()
        let controller = ReviewPromptController(reviewPromptAction: reviewPromptAction,
                                                eventsService: eventsService)
        eventsService.simulateEventFavourited(identifier: .random)
        eventsService.simulateEventFavourited(identifier: .random)
        eventsService.simulateEventFavourited(identifier: .random)
        
        XCTAssertTrue(reviewPromptAction.didShowReviewPrompt)
    }
    
    func testNotShowTheReviewPromptBeforeTheThirdFavourite() {
        let reviewPromptAction = CapturingReviewPromptAction()
        let eventsService = FakeEventsService()
        let controller = ReviewPromptController(reviewPromptAction: reviewPromptAction,
                                                eventsService: eventsService)
        eventsService.simulateEventFavourited(identifier: .random)
        eventsService.simulateEventFavourited(identifier: .random)
        
        XCTAssertFalse(reviewPromptAction.didShowReviewPrompt)
    }
    
}
