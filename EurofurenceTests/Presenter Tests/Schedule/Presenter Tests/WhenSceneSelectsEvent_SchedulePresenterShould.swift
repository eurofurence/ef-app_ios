//
//  WhenSceneSelectsEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSceneSelectsEvent_SchedulePresenterShould: XCTestCase {

    func testTellModuleEventWithResolvedIdentifierSelected() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let selectedIdentifier = Event.Identifier.random
        viewModel.stub(selectedIdentifier, at: indexPath)
        context.simulateSceneDidSelectEvent(at: indexPath)

        XCTAssertEqual(selectedIdentifier, context.delegate.capturedEventIdentifier)
    }

    func testTellTheSceneToDeselectTheSelectedEvent() {
        let context = SchedulePresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath.random
        context.simulateSceneDidSelectEvent(at: indexPath)

        XCTAssertEqual(indexPath, context.scene.deselectedEventIndexPath)
    }

}
