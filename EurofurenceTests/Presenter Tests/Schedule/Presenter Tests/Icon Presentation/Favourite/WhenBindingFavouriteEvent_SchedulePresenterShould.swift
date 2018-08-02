//
//  WhenBindingFavouriteEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingFavouriteEvent_SchedulePresenterShould: XCTestCase {
    
    func testTellTheSceneToShowTheFavouriteEventIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertTrue(component.didShowFavouriteEventIndicator)
    }
    
    func testNotTellTheSceneToHideTheFavouriteEventIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)
        
        XCTAssertFalse(component.didHideFavouriteEventIndicator)
    }
    
    func testSupplyUnfavouriteActionInformation() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionForComponent(at: indexPath)
        
        XCTAssertEqual(.unfavourite, action?.title)
    }
    
    func testTellViewModelToUnfavouriteEventAtIndexPathWhenInvokingAction() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = true
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionForComponent(at: indexPath)
        action?.run()
        
        XCTAssertEqual(indexPath, viewModel.indexPathForUnfavouritedEvent)
    }
    
}
