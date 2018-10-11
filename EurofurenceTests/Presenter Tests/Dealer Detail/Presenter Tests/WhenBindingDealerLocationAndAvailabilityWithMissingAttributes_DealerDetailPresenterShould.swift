//
//  WhenBindingDealerLocationAndAvailabilityWithMissingAttributes_DealerDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingDealerLocationAndAvailabilityWithMissingAttributes_DealerDetailPresenterShould: XCTestCase {

    func testTellTheComponentToHideTheMap() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(true, context.boundLocationAndAvailabilityComponent?.didHideMap)
    }

    func testTellTheComponentToHideTheLimitedAvailabilityWarning() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(true, context.boundLocationAndAvailabilityComponent?.didHideLimitedAvailbilityWarning)
    }

    func testTellTheComponentToHideTheAfterDarkDenNotice() {
        var locationAndAvailabilityViewModel = DealerDetailLocationAndAvailabilityViewModel.random
        locationAndAvailabilityViewModel.mapPNGGraphicData = nil
        locationAndAvailabilityViewModel.limitedAvailabilityWarning = nil
        locationAndAvailabilityViewModel.locatedInAfterDarkDealersDenMessage = nil
        let viewModel = FakeDealerDetailLocationAndAvailabilityViewModel(location: locationAndAvailabilityViewModel)
        let interactor = FakeDealerDetailInteractor(viewModel: viewModel)
        let context = DealerDetailPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.bindComponent(at: 0)

        XCTAssertEqual(true, context.boundLocationAndAvailabilityComponent?.didHideAfterDarkDenNotice)
    }

}
