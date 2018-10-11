//
//  WhenViewModelRefreshStateChanges_DealersPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenViewModelRefreshStateChanges_DealersPresenterShould: XCTestCase {

    func testTellTheSceneToShowTheRefreshingIndicatorWhenRefreshBegins() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        viewModel.delegate?.dealersRefreshDidBegin()

        XCTAssertTrue(context.scene.didShowRefreshIndicator)
    }

    func testTellTheSceneToHideTheRefreshingIndicatorWhenRefreshFinishes() {
        let viewModel = CapturingDealersViewModel()
        let interactor = FakeDealersInteractor(viewModel: viewModel)
        let context = DealersPresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        viewModel.delegate?.dealersRefreshDidFinish()

        XCTAssertTrue(context.scene.didHideRefreshIndicator)
    }

}
