//
//  WhenInstigatingPullToRefreshAction_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 01/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenInstigatingPullToRefreshAction_SchedulePresenterShould: XCTestCase {

    func testTellTheViewModelToRefresh() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()

        XCTAssertTrue(viewModel.didPerformRefresh)
    }

    func testShowTheRefreshIndicatorWhenRefreshBegins() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()
        viewModel.simulateScheduleRefreshDidBegin()

        XCTAssertTrue(context.scene.didShowRefreshIndicator)
    }

    func testHideTheRefreshIndicatorWhenRefreshFinishes() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidPerformRefreshAction()
        viewModel.simulateScheduleRefreshDidBegin()
        viewModel.simulateScheduleRefreshDidFinish()

        XCTAssertTrue(context.scene.didHideRefreshIndicator)
    }

}
