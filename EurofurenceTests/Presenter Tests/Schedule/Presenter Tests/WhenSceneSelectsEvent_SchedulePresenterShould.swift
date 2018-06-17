//
//  WhenSceneSelectsEvent_SchedulePresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenSceneSelectsEvent_SchedulePresenterShould: XCTestCase {
    
    func testTellModuleEventWithResolvedIdentifierSelected() {
        let viewModel = CapturingScheduleViewModel.random
        let interactor = FakeScheduleInteractor(viewModel: viewModel)
        let context = SchedulePresenterTestBuilder().with(interactor).build()
        context.simulateSceneDidLoad()
        let randomGroup = viewModel.events.randomElement()
        let randomEvent = randomGroup.element.events.randomElement()
        let indexPath = IndexPath(item: randomEvent.index, section: randomGroup.index)
        let selectedIdentifier = Event2.Identifier.random
        viewModel.stub(selectedIdentifier, at: indexPath)
        context.simulateSceneDidSelectEvent(at: indexPath)
        
        XCTAssertEqual(selectedIdentifier, context.delegate.capturedEventIdentifier)
    }
    
}
