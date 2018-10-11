//
//  WhenBindingDealerLocationAndAvailability_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingDealerLocationAndAvailability_DealerDetailPresenterShould: XCTestCase {

    func testBindTheProducedMapGraphicFromTheViewModelOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.mapPNGGraphicData, context.boundLocationAndAvailabilityComponent?.capturedMapPNGGraphicData)
    }

    func testBindTheLimitedAvailabilityWarningFromTheViewModelOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.limitedAvailabilityWarning, context.boundLocationAndAvailabilityComponent?.capturedLimitedAvailabilityWarning)
    }

    func testBindTheLocatedInAfterDarkDealersDenNoticeOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage, context.boundLocationAndAvailabilityComponent?.capturedLocatedInAfterDarkDealersDenMessage)
    }

    func testBindTheLocationAndAvailabilityTitleOntoTheComponent() {
        let locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(locationAndAvailabilityViewModel.title, context.boundLocationAndAvailabilityComponent?.capturedTitle)
    }

}
