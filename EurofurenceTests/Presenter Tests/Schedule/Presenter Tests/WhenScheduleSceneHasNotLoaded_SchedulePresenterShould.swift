//
//  WhenScheduleSceneHasNotLoaded_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenScheduleSceneHasNotLoaded_SchedulePresenterShould: XCTestCase {

    func testNotBindAnyItems() {
        let context = SchedulePresenterTestBuilder().build()
        XCTAssertTrue(context.scene.boundItemsPerSection.isEmpty)
    }

}
