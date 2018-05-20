//
//  WhenEventDetailInteractorProducesViewModel_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenEventDetailInteractorProducesViewModel_EventDetailPresenterShould: XCTestCase {
    
    var context: EventDetailPresenterTestBuilder.Context!
    var viewModel: StubEventDetailViewModel!
    
    override func setUp() {
        super.setUp()
        
        let event = Event2.random
        viewModel = StubEventDetailViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
    }
    
    func testApplyTheTitleOntoTheScene() {
        XCTAssertEqual(viewModel.title, context.scene.stubbedEventSummaryComponent.capturedTitle)
    }
    
    func testApplyTheEventStartTimeOntoTheScene() {
        XCTAssertEqual(viewModel.eventStartTime, context.scene.stubbedEventSummaryComponent.capturedEventStartTime)
    }
    
    func testApplyTheEventLocationOntoTheScene() {
        XCTAssertEqual(viewModel.location, context.scene.stubbedEventSummaryComponent.capturedEventLocation)
    }
    
    func testApplyTheTrackNameOntoTheScene() {
        XCTAssertEqual(viewModel.trackName, context.scene.stubbedEventSummaryComponent.capturedTrackName)
    }
    
}
