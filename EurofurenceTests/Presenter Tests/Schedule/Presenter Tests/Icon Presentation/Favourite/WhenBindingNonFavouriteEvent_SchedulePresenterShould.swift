//
//  WhenBindingNonFavouriteEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 03/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingNonFavouriteEvent_SchedulePresenterShould: XCTestCase {

    func testNotTellTheSceneToShowTheFavouriteEventIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertFalse(component.didShowFavouriteEventIndicator)
    }

    func testTellTheSceneToHideTheFavouriteEventIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let component = SchedulePresenterTestBuilder.buildForTestingBindingOfEvent(eventViewModel)

        XCTAssertTrue(component.didHideFavouriteEventIndicator)
    }

    func testSupplyFavouriteActionInformation() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = false
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        var searchResult = ScheduleEventViewModel.random
        searchResult.isFavourite = false
        let indexPath = IndexPath(item: 0, section: 0)
        let action = context.scene.binder?.eventActionForComponent(at: indexPath)

        XCTAssertEqual(.favourite, action?.title)
    }

    func testTellViewModelToFavouriteEventAtIndexPathWhenInvokingAction() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isFavourite = false
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

        XCTAssertEqual(indexPath, viewModel.indexPathForFavouritedEvent)
    }

}
