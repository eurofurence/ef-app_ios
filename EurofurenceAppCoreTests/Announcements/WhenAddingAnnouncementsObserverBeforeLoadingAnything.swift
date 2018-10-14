//
//  WhenAddingAnnouncementsObserverBeforeLoadingAnything.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 25/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceAppCore
import XCTest

class WhenAddingAnnouncementsObserverBeforeLoadingAnything: XCTestCase {

    var observer: CapturingAnnouncementsServiceObserver!

    override func setUp() {
        super.setUp()

        let context = ApplicationTestBuilder().build()
        observer = CapturingAnnouncementsServiceObserver()
        context.application.add(observer)
    }

    func testEmptyAnnouncementsAreReturned() {
        XCTAssertTrue(observer.didReceieveEmptyAllAnnouncements)
    }

    func testEmptyReadAnnouncementsAreReturned() {
        XCTAssertTrue(observer.didReceieveEmptyReadAnnouncements)
    }

}
