//
//  WhenBindingEvent_NewsPresenterShould.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 16/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCore
import XCTest

class EventsViewModel: NewsViewModel {
    
    var events: [[EventComponentViewModel]]
    
    init() {
        events = (0...Int.random(upperLimit: 5) + 1).map { (index) -> [EventComponentViewModel] in
            return [EventComponentViewModel].random
        }
    }
    
    var numberOfComponents: Int {
        return events.count
    }
    
    func numberOfItemsInComponent(at index: Int) -> Int {
        return events[index].count
    }
    
    func titleForComponent(at index: Int) -> String {
        return "Events"
    }
    
    func describeComponent(at indexPath: IndexPath, to visitor: NewsViewModelVisitor) {
        let event = events[indexPath.section][indexPath.row]
        visitor.visit(event)
    }
    
    private var models = [IndexPath : NewsViewModelValue]()
    func fetchModelValue(at indexPath: IndexPath, completionHandler: @escaping (NewsViewModelValue) -> Void) {
        if let model = models[indexPath] {
            completionHandler(model)
        }
    }
    
    func stub(_ model: NewsViewModelValue, at indexPath: IndexPath) {
        models[indexPath] = model
    }
    
}

class WhenBindingEvent_NewsPresenterShould: XCTestCase {
    
    var viewModel: EventsViewModel!
    var eventViewModel: EventComponentViewModel!
    var indexPath: IndexPath!
    var newsInteractor: StubNewsInteractor!
    var context: NewsPresenterTestBuilder.Context!
    var boundComponent: Any?
    
    override func setUp() {
        super.setUp()
        
        viewModel = EventsViewModel()
        let component = viewModel.events.randomElement()
        let event = component.element.randomElement()
        eventViewModel = event.element
        indexPath = IndexPath(row: event.index, section: component.index)
        
        newsInteractor = StubNewsInteractor(viewModel: viewModel)
        context = NewsPresenterTestBuilder().with(newsInteractor).build()
        context.simulateNewsSceneDidLoad()
        boundComponent = context.bindSceneComponent(at: indexPath)
    }
    
    func testReturnTheEventComponentWhenBinding() {
        XCTAssertTrue(context.newsScene.stubbedEventComponent === (boundComponent as? CapturingScheduleEventComponent))
    }
    
    func testBindTheStartTimeFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.startTime, context.newsScene.stubbedEventComponent.capturedStartTime)
    }
    
    func testBindTheEndTimeFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.endTime, context.newsScene.stubbedEventComponent.capturedEndTime)
    }
    
    func testBindTheEventNameFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.eventName, context.newsScene.stubbedEventComponent.capturedEventTitle)
    }
    
    func testBindTheEventLocationFromTheEventOntoTheEventScene() {
        XCTAssertEqual(eventViewModel.location, context.newsScene.stubbedEventComponent.capturedLocation)
    }
    
    func testTellTheDelegateEventSelectedWhenSceneSelectsComponentAtIndexPath() {
        let event = Event2.random
        viewModel.stub(.event(event), at: indexPath)
        context.selectComponent(at: indexPath)
        
        XCTAssertEqual(event, context.delegate.capturedEvent)
    }
    
}
