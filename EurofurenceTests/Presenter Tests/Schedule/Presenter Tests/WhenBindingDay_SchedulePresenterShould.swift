//
//  WhenBindingDay_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

class WhenBindingDay_SchedulePresenterShould: XCTestCase {
    
    func testBindTheDayNameOntoTheComponent() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomDay = viewModel.days.randomElement()
        let component = CapturingScheduleDayComponent()
        context.bind(component, forDayAt: randomDay.index)
        
        XCTAssertEqual(randomDay.element.title, component.capturedTitle)
    }
    
}
