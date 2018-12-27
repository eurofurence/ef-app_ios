//
//  WhenBindingNonFavouriteEvent_FromSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingNonFavouriteEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {

    func testNotTellTheSceneToShowTheFavouriteEventIndicator() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)

        XCTAssertFalse(component.didShowFavouriteEventIndicator)
    }

    func testTellTheSceneToHideTheFavouriteEventIndicator() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)

        XCTAssertTrue(component.didHideFavouriteEventIndicator)
    }

    func testSupplyFavouriteActionInformation() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)

        XCTAssertEqual(.favourite, action?.title)
    }

    func testTellViewModelToFavouriteEventAtIndexPathWhenInvokingAction() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)
        action?.run()

        XCTAssertEqual(indexPath, searchViewModel.indexPathForFavouritedEvent)
    }

}
