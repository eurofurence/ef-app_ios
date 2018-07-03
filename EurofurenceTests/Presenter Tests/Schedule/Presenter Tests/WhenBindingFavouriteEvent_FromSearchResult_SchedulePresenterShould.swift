//
//  WhenBindingFavouriteEvent_FromSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingFavouriteEvent_FromSearchResult_SchedulePresenterShould: XCTestCase {
    
    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)
        
        XCTAssertTrue(component.didShowFavouriteEventIndicator)
    }
    
    func testNotTellTheSceneToHideTheFavouriteEventIndicator() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = true
        let results = [ScheduleEventGroupViewModel(title: .random, events: [searchResult])]
        searchViewModel.simulateSearchResultsUpdated(results)
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)
        
        XCTAssertFalse(component.didHideFavouriteEventIndicator)
    }
    
}
