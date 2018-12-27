//
//  WhenSearchableViewModelProducesNewResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenSearchableViewModelProducesNewResult_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToBindExpectedNumberOfResultsPerSection() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel].random
        let expected = results.map({ $0.events.count })
        searchViewModel.simulateSearchResultsUpdated(results)

        XCTAssertEqual(expected, context.scene.boundSearchItemsPerSection)
    }

}
