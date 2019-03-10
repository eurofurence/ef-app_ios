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

    func testPrepareTheComponentToShowFavouriteEventAction() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let searchResult = StubScheduleEventViewModel.random
        searchResult.isFavourite = false
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)
        let action = context.scene.searchResultsBinder?.eventActionForComponent(at: indexPath)
        action?.run()

        XCTAssertEqual(component.favouriteIconVisibility, .hidden)
        XCTAssertEqual(.favourite, action?.title)
        XCTAssertEqual(indexPath, searchViewModel.indexPathForFavouritedEvent)
    }

}
