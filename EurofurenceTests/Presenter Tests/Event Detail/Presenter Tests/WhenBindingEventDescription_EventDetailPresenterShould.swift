//
//  WhenBindingEventDescription_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

struct StubEventDescriptionViewModel: EventDetailViewModel {
    
    var numberOfComponents: Int = .random
    var eventDescription: EventDescriptionViewModel = .random
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(eventDescription)
    }
    
}

class WhenBindingEventDescription_EventDetailPresenterShould: XCTestCase {
    
    func testApplyTheEventDescriptionOntoTheScene() {
        let event = Event2.random
        let viewModel = StubEventDescriptionViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        _ = context.scene.bindComponent(at: IndexPath(item: 1, section: 0))
        
        XCTAssertEqual(viewModel.eventDescription.contents, context.scene.stubbedEventDescriptionComponent.capturedEventDescription)
    }
    
    func testReturnTheDescriptionComponent() {
        let event = Event2.random
        let viewModel = StubEventDescriptionViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        let context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        let boundComponent = context.scene.bindComponent(at: IndexPath(item: 1, section: 0))
        
        XCTAssertTrue((boundComponent as? CapturingEventDescriptionComponent) === context.scene.stubbedEventDescriptionComponent)
    }
    
}
