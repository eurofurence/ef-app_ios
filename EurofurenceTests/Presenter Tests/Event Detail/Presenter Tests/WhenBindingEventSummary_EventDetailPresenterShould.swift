//
//  WhenEventDetailInteractorProducesViewModel_EventDetailPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 20/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import XCTest

class WhenBindingEventSummary_EventDetailPresenterShould: XCTestCase {
    
    var context: EventDetailPresenterTestBuilder.Context!
    var viewModel: StubEventSummaryViewModel!
    var boundComponent: Any?
    
    override func setUp() {
        super.setUp()
        
        let event = Event2.random
        viewModel = StubEventSummaryViewModel()
        let interactor = FakeEventDetailInteractor(viewModel: viewModel, for: event)
        context = EventDetailPresenterTestBuilder().with(interactor).build(for: event)
        context.simulateSceneDidLoad()
        boundComponent = context.scene.bindComponent(at: IndexPath(item: 0, section: 0))
    }
    
    func testTellTheSceneToBindTheExpectedNumberOfComponents() {
        XCTAssertEqual(viewModel.numberOfComponents, context.scene.numberOfBoundsComponents)
    }
    
    func testApplyTheTitleOntoTheScene() {
        XCTAssertEqual(viewModel.summary.title, context.scene.stubbedEventSummaryComponent.capturedTitle)
    }
    
    func testApplyTheSubtitleOntoTheScene() {
        XCTAssertEqual(viewModel.summary.subtitle, context.scene.stubbedEventSummaryComponent.capturedSubtitle)
    }
    
    func testApplyTheEventStartTimeOntoTheScene() {
        XCTAssertEqual(viewModel.summary.eventStartEndTime, context.scene.stubbedEventSummaryComponent.capturedEventStartTime)
    }
    
    func testApplyTheEventLocationOntoTheScene() {
        XCTAssertEqual(viewModel.summary.location, context.scene.stubbedEventSummaryComponent.capturedEventLocation)
    }
    
    func testApplyTheTrackNameOntoTheScene() {
        XCTAssertEqual(viewModel.summary.trackName, context.scene.stubbedEventSummaryComponent.capturedTrackName)
    }
    
    func testApplyTheEventHostsOntoTheScene() {
        XCTAssertEqual(viewModel.summary.eventHosts, context.scene.stubbedEventSummaryComponent.capturedEventHosts)
    }
    
    func testReturnTheBoundEventSummaryComponent() {
        XCTAssertTrue((boundComponent as? CapturingEventSummaryComponent) === context.scene.stubbedEventSummaryComponent)
    }
    
}
