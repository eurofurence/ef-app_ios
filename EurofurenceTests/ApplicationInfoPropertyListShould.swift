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

    private func objectFromMainBundlePropertyList<T>(forInfoDictionaryKey key: String) -> T? {
        let bundle = Bundle(for: AppDelegate.self)
        return bundle.object(forInfoDictionaryKey: key) as? T
    }

    func testContainTheCalendarUsageKey() {
        let calendarUsageDescription: String? = objectFromMainBundlePropertyList(forInfoDictionaryKey: "NSCalendarsUsageDescription")
        let expectedDescription = "Eurofurence uses your calendar to add events and alerts"

        XCTAssertNotNil(calendarUsageDescription)
        XCTAssertEqual(expectedDescription, calendarUsageDescription)
    }

}
