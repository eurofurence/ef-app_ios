//
//  WhenSceneTapsFavouriteEventButton_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import XCTest

class WhenSceneTapsFavouriteEventButton_EventDetailPresenterShould: XCTestCase {

    func testInvokeTheFavouriteActionOnTheViewModel() {
        let event = Event.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.simulateFavouriteEventButtonTapped()

        XCTAssertTrue(viewModel.wasToldToFavouriteEvent)
    }

    func testPlaySelectionHaptic() {
        let context = EventDetailPresenterTestBuilder().build()
        context.simulateSceneDidLoad()
        context.scene.simulateFavouriteEventButtonTapped()

        XCTAssertTrue(context.hapticEngine.didPlaySelectionHaptic)
    }

}
