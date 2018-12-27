//
//  WhenSceneSelectsEventFromSearchViewModel_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 18/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenSceneSelectsEventFromSearchViewModel_SchedulePresenterShould: XCTestCase {

    func testTellModuleEventWithResolvedIdentifierSelected() {
        let searchViewModel = CapturingScheduleSearchViewModel()
        let interactor = FakeScheduleInteractor(searchViewModel: searchViewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        let results = [ScheduleEventGroupViewModel].random
        context.simulateSceneDidLoad()
        searchViewModel.simulateSearchResultsUpdated(results)
        let randomGroup = results.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let selectedIdentifier = Event.Identifier.random
        searchViewModel.stub(selectedIdentifier, at: indexPath)
        context.simulateSceneDidSelectSearchResult(at: indexPath)

        XCTAssertEqual(selectedIdentifier, context.delegate.capturedEventIdentifier)
    }

    func testTellTheSceneToDeselectTheSelectedSearchResult() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath.random
        context.simulateSceneDidSelectSearchResult(at: indexPath)

        XCTAssertEqual(indexPath, context.scene.deselectedSearchResultIndexPath)
    }

}
