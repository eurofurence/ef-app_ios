//
//  WhenViewModelIndicatesEventIsFavourite_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 31/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenViewModelIndicatesEventIsFavourite_EventDetailPresenterShould: XCTestCase {

    func testShowTheUnfavouriteEventButton() {
        let event = Event.random
        let viewModel = CapturingEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        viewModel.simulateFavourited()

        XCTAssertTrue(context.scene.didShowUnfavouriteEventButton)
    }

}
