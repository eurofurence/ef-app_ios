//
//  WhenSceneChangesSearchScopeToFavouriteEvents_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenSceneChangesSearchScopeToFavouriteEvents_SchedulePresenterShould: XCTestCase {

    func testTellTheSearchViewModelToFilterToFavourites() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()

        XCTAssertTrue(searchViewModel.didFilterToFavourites)
    }

    func testTellTheSearchResultsToAppear() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()

        XCTAssertTrue(context.scene.didShowSearchResults)
    }

    func testTellTheSearchResultsToAppearWhenQueryChangesToEmptyString() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.delegate?.scheduleSceneDidChangeSearchScopeToFavouriteEvents()
        context.scene.delegate?.scheduleSceneDidUpdateSearchQuery("")

        XCTAssertEqual(2, context.scene.didShowSearchResultsCount)
    }

}
