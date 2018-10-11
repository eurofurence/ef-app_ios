//
//  NewsPresenterSuperSponsorIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class NewsPresenterSuperSponsorIconBindingTests: XCTestCase {

    func testShowTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertTrue(component.didShowSuperSponsorOnlyEventIndicator)
        XCTAssertFalse(component.didHideSuperSponsorOnlyEventIndicator)
    }

    func testHideTheSuperSponsorOnlyIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isSuperSponsorEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertFalse(component.didShowSuperSponsorOnlyEventIndicator)
        XCTAssertTrue(component.didHideSuperSponsorOnlyEventIndicator)
    }

}
