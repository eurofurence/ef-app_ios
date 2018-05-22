//
//  WhenBindingEventDescription_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingEventDescription_EventDetailPresenterShould: XCTestCase {
    
    func testApplyTheEventDescriptionOntoTheScene() {
        let event = Event2.random
        let viewModel = StubEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        _ = context.scene.bindComponent(at: IndexPath(item: 1, section: 0))
        
        XCTAssertEqual(viewModel.eventDescription, context.scene.stubbedEventDescriptionComponent.capturedEventDescription)
    }
    
}
