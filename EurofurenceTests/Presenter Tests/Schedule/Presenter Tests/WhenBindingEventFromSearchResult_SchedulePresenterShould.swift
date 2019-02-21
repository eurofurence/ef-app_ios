//
//  WhenBindingEventFromSearchResult_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenBindingEventFromSearchResult_SchedulePresenterShould: XCTestCase {

    func testBindTheEventAttributesOntoTheComponent() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let results = [ScheduleEventGroupViewModel].random
        searchViewModel.simulateSearchResultsUpdated(results)
        let randomGroup = results.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let eventViewModel = randomEvent.element
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let component = CapturingScheduleEventComponent()
        context.bindSearchResultComponent(component, forSearchResultAt: indexPath)

        XCTAssertEqual(eventViewModel.title, component.capturedEventTitle)
        XCTAssertEqual(eventViewModel.startTime, component.capturedStartTime)
        XCTAssertEqual(eventViewModel.endTime, component.capturedEndTime)
        XCTAssertEqual(eventViewModel.location, component.capturedLocation)
    }

}
