//
//  WhenSceneUpdatesSearchQuery_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenSceneUpdatesSearchQuery_SchedulePresenterShould: XCTestCase {

    func testTellTheSearchableViewModelToUpdateItsResults() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = String.random
        context.simulateSceneDidUpdateSearchQuery(expected)

        XCTAssertEqual(expected, searchViewModel.capturedSearchInput)
    }

}
