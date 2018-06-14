//
//  WhenScheduleSceneLoads_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 12/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenScheduleSceneLoads_SchedulePresenterShould: XCTestCase {
    
    func testBindNumberOfConferenceDaysOntoTheScene() {
        let viewModel = StubScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = viewModel.days.count
        
        XCTAssertEqual(expected, context.scene.boundNumberOfDays)
    }
    
    func testBindNumberOfGroupsOntoScheduleScene() {
        let viewModel = StubScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let expected = viewModel.events.map({ $0.events.count })
        
        XCTAssertEqual(expected, context.scene.boundItemsPerSection)
    }
    
}
