//
//  WhenBindingSuperSponsorOnlyEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/08/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingSuperSponsorOnlyEvent_SchedulePresenterShould: XCTestCase {
    
    func testShowTheSponsorOnlyIndicator() {
        var eventViewModel = ScheduleEventViewModel.random
        eventViewModel.isSuperSponsorOnly = true
        let eventGroupViewModel = ScheduleEventGroupViewModel(title: .random, events: [eventViewModel])
        let viewModel = CapturingScheduleViewModel(days: .random, events: [eventGroupViewModel], currentDay: 0)
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let indexPath = IndexPath(item: 0, section: 0)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
        
        XCTAssertTrue(component.didShowSuperSponsorOnlyEventIndicator)
    }
    
}
