//
//  WhenBindingFavouriteEvent_FromSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingFavouriteEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {

    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)

        XCTAssertTrue(component.didShowFavouriteEventIndicator)
    }

    func testNotTellTheSceneToHideTheFavouriteEventIndicator() {
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfSearchResult(searchResult)

        XCTAssertFalse(component.didHideFavouriteEventIndicator)
    }

    func testSupplyUnfavouriteActionInformation() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)

        XCTAssertEqual(.unfavourite, action?.title)
    }

    func testTellViewModelToUnfavouriteEventAtIndexPathWhenInvokingAction() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)
        action?.run()

        XCTAssertEqual(indexPath, searchViewModel.indexPathForUnfavouritedEvent)
    }

}
