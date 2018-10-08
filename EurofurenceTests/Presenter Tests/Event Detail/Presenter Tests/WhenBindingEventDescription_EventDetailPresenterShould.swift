//
//  WhenBindingEventDescription_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 22/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import XCTest

struct StubEventDescriptionViewModel: EventDetailViewModel {
    
    var numberOfComponents: Int = .random
    private let eventDescription: EventDescriptionViewModel
    private let expectedIndex: Int
    
    init(eventDescription: EventDescriptionViewModel, at index: Int) {
        self.eventDescription = eventDescription
        expectedIndex = index
    }
    
    func setDelegate(_ delegate: EventDetailViewModelDelegate) {
        
    }
    
    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(eventDescription.randomized(ifFalse: index == expectedIndex))
    }
    
    func favourite() {
        
    }
    
    func unfavourite() {
        
    }
    
}

class WhenBindingEventDescription_EventDetailPresenterShould: XCTestCase {
    
    var context: EventDetailPresenterTestBuilder.Context!
    var eventDescription: EventDescriptionViewModel!
    var boundComponent: Any?
    
    override func setUp() {
        super.setUp()
        
        let event = Event2.random
        eventDescription = .random
        let index = Int.random
        let viewModel = StubEventDescriptionViewModel(eventDescription: eventDescription, at: index)
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        boundComponent = context.scene.bindComponent(at: IndexPath(item: index, section: 0))
    }
    
    func testApplyTheEventDescriptionOntoTheScene() {
        XCTAssertEqual(eventDescription.contents, context.scene.stubbedEventDescriptionComponent.capturedEventDescription)
    }
    
    func testReturnTheDescriptionComponent() {
        XCTAssertTrue((boundComponent as? CapturingEventDescriptionComponent) === context.scene.stubbedEventDescriptionComponent)
    }
    
}
