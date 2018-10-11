//
//  WhenSceneTapsUnfavouriteEventButton_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSceneTapsUnfavouriteEventButton_EventDetailPresenterShould: XCTestCase {

    func testInvokeTheUnfavouriteActionOnTheViewModel() {
        let event = Event.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.simulateUnfavouriteEventButtonTapped()

        XCTAssertTrue(viewModel.wasToldToUnfavouriteEvent)
    }

    func testPlaySelectionHaptic() {
        let context = EventDetailPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateUnfavouriteEventButtonTapped()

        XCTAssertTrue(context.hapticEngine.didPlaySelectionHaptic)
    }

}
