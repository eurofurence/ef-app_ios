//
//  NewsPresenterKageIconBindingTests.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 08/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class NewsPresenterKageIconBindingTests: XCTestCase {

    func testShowTheKageIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isKageEvent = true
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.kageIconVisibility, .visible)
    }

    func testHideTheKageIndicator() {
        var eventViewModel: EventComponentViewModel = .random
        eventViewModel.isKageEvent = false
        let component = NewsPresenterTestBuilder.buildForAssertingAgainstEventComponent(eventViewModel: eventViewModel)

        XCTAssertEqual(component.kageIconVisibility, .hidden)
    }

}
