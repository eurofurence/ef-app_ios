//
//  ApplicationInfoPropertyListShould.swift
//  Eurofurence
//
//  Created by ShezHsky on 05/07/2017.
//  Copyright © 2017 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class ApplicationInfoPropertyListShould: XCTestCase {
    
    func testContainTheCalendarUsageKey() {
        let bundle = Bundle(for: AppDelegate.self)
        let calendarUsageDescription = bundle.object(forInfoDictionaryKey: "NSCalendarsUsageDescription")

        XCTAssertNotNil(calendarUsageDescription)
    }

    func testContainSuitableDescriptionForCalendarUsage() {
        let bundle = Bundle(for: AppDelegate.self)
        let calendarUsageDescription = bundle.object(forInfoDictionaryKey: "NSCalendarsUsageDescription") as? String
        let expectedDescription = "Eurofurence uses your calendar to add events and alerts"

        XCTAssertEqual(expectedDescription, calendarUsageDescription)
    }
    
}
