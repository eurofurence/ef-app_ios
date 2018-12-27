//
//  WhenScheduleSceneSelectsDay_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 15/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenScheduleSceneSelectsDay_SchedulePresenterShould: XCTestCase {

    func testTellViewModelToUpdateForEventsOnDayAtIndex() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomDay = viewModel.days.randomElement()
        context.simulateSceneDidSelectDay(at: randomDay.index)

        XCTAssertEqual(randomDay.index, viewModel.capturedDayToShowIndex)
    }

    func testTellTheHapticEngineToPlaySelectionHaptic() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomDay = viewModel.days.randomElement()
        context.simulateSceneDidSelectDay(at: randomDay.index)

        XCTAssertTrue(context.hapticEngine.didPlaySelectionHaptic)
    }

}
