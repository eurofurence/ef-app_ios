//
//  WhenBindingEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 13/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingEvent_SchedulePresenterShould: XCTestCase {
    
    func testBindTheEventNameOntoTheComponent() {
        let viewModel = ScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.eventGroups.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let component = CapturingScheduleEventComponent()
        context.bind(component, forEventAt: indexPath)
        
        XCTAssertEqual(component.capturedEventTitle, randomEvent.element.title)
    }
    
}
