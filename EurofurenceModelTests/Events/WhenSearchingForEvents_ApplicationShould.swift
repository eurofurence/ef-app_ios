//
//  WhenSearchingForEvents_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSearchingForEvents_ApplicationShould: XCTestCase {

    func testReturnExactMatchesOnTitles() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let randomEvent = syncResponse.events.changed.randomElement().element
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm(randomEvent.title)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertEqual([expected], delegate.capturedSearchResults)
    }

    func testReturnFuzzyMatchesOnTitles() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        context.performSuccessfulSync(response: syncResponse)
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let randomEvent = syncResponse.events.changed.randomElement().element
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        let partialTitle = String(randomEvent.title.dropLast())
        eventsSearchController.changeSearchTerm(partialTitle)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)

        XCTAssertEqual([expected], delegate.capturedSearchResults)
    }

    func testBeCaseInsensitive() {
        let context = ApplicationTestBuilder().build()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement()
        var event = randomEvent.element
        event.title = "iGNoRe tHe rANdoM CAsing"
        syncResponse.events.changed[randomEvent.index] = event
        context.performSuccessfulSync(response: syncResponse)
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm("random")
        let expected = context.makeExpectedEvent(from: event, response: syncResponse)

        XCTAssertEqual([expected], delegate.capturedSearchResults)
    }

}
