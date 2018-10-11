//
//  NewsPresenterArtShowIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 07/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class NewsPresenterArtShowIconBindingTests: XCTestCase {

    func testShowTheArtShowIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isArtShowEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertTrue(component.didShowArtShowEventIndicator)
        XCTAssertFalse(component.didHideArtShowEventIndicator)
    }

    func testHideTheArtShowIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isArtShowEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertFalse(component.didShowArtShowEventIndicator)
        XCTAssertTrue(component.didHideArtShowEventIndicator)
    }

}
