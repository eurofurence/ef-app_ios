//
//  WhenSearchingForEvents_BeforeAnyAreAvailable_ApplicationShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenSearchingForEvents_BeforeAnyAreAvailable_ApplicationShould: XCTestCase {

    func testProduceEmptyResults() {
        let context = EurofurenceSessionTestBuilder().build()
        let eventsSearchController = context.eventsService.makeEventsSearchController()
        let delegate = CapturingEventsSearchControllerDelegate()
        eventsSearchController.setResultsDelegate(delegate)
        eventsSearchController.changeSearchTerm(.random)

        XCTAssertTrue(delegate.toldSearchResultsUpdatedToEmptyArray)
    }

}
