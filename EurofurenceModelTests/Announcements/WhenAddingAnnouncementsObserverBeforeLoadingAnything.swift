//
//  WhenAddingAnnouncementsObserverBeforeLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import XCTest

class WhenAddingAnnouncementsObserverBeforeLoadingAnything: XCTestCase {

    func testEmptyAnnouncementsAreStillPropogatedToTheObserver() {
        let context = ApplicationTestBuilder().build()
        let observer = CapturingAnnouncementsServiceObserver()
        context.announcementsService.add(observer)

        XCTAssertTrue(observer.didReceieveEmptyAllAnnouncements)
        XCTAssertTrue(observer.didReceieveEmptyReadAnnouncements)
    }

}
