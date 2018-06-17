//
//  WhenSearchingForEvents_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSearchingForEvents_ApplicationShould: XCTestCase {
    
    func testReturnExactMatchesOnTitles() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let eventsSearchController = context.application.makeEventsSearchController()
        let randomEvent = syncResponse.events.changed.randomElement().element
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm(randomEvent.title)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)
        
        XCTAssertEqual([expected], delegate.capturedSearchResults)
    }
    
    func testReturnFuzzyMatchesOnTitles() {
        let context = ApplicationTestBuilder().build()
        let syncResponse = APISyncResponse.randomWithoutDeletions
        context.refreshLocalStore()
        context.syncAPI.simulateSuccessfulSync(syncResponse)
        let eventsSearchController = context.application.makeEventsSearchController()
        let randomEvent = syncResponse.events.changed.randomElement().element
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        let partialTitle = String(randomEvent.title.dropLast())
        eventsSearchController.changeSearchTerm(partialTitle)
        let expected = context.makeExpectedEvent(from: randomEvent, response: syncResponse)
        
        XCTAssertEqual([expected], delegate.capturedSearchResults)
    }
    
}
