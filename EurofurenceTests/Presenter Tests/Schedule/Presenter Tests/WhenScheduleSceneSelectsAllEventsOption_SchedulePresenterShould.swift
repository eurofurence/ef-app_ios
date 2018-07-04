//
//  WhenScheduleSceneSelectsAllEventsOption_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenScheduleSceneSelectsAllEventsOption_SchedulePresenterShould: XCTestCase {
    
    func testTellTheViewModelToShowAllEvents() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        context.simulateSceneDidSelectAllEventsOption()
        
        XCTAssertTrue(viewModel.toldToShowAllEvents)
    }
    
}
