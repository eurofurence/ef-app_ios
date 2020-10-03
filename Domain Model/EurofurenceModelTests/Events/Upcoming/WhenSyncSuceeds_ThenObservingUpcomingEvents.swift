import EurofurenceModel
import XCTest

class WhenSyncSuceeds_ThenObservingUpcomingEvents: XCTestCase {

    func testTheObserverIsProvidedWithTheUpcomingEvents() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.upcomingEvents, containsEventCharacterisedBy: randomEvent)
    }
    
    func testUpcomingEventsAreDeliveredInStartTimeOrder() {
        let now = Date()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstEvent = syncResponse.events.changed[0]
        firstEvent.startDateTime = now.addingTimeInterval(1000)
        firstEvent.endDateTime = firstEvent.startDateTime.addingTimeInterval(100)
        var secondEvent = syncResponse.events.changed[1]
        secondEvent.startDateTime = now.addingTimeInterval(100)
        secondEvent.endDateTime = secondEvent.startDateTime.addingTimeInterval(100)
        syncResponse.events = .init(changed: [firstEvent, secondEvent], deleted: [], removeAllBeforeInsert: false)
        let context = EurofurenceSessionTestBuilder().with(now).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        
        let firstRealEvent = observer.upcomingEvents[0]
        let secondRealEvent = observer.upcomingEvents[1]
        
        XCTAssertEqual(firstRealEvent.identifier, EventIdentifier(secondEvent.identifier))
        XCTAssertEqual(secondRealEvent.identifier, EventIdentifier(firstEvent.identifier))
    }
    
    func testUpcomingEventsAreDeliveredInStartTimeThenTitleOrder() {
        let now = Date()
        var syncResponse = ModelCharacteristics.randomWithoutDeletions
        var firstEvent = syncResponse.events.changed[0]
        firstEvent.startDateTime = now.addingTimeInterval(100)
        firstEvent.endDateTime = firstEvent.startDateTime.addingTimeInterval(100)
        firstEvent.title = "Z"
        var secondEvent = syncResponse.events.changed[1]
        secondEvent.startDateTime = now.addingTimeInterval(100)
        secondEvent.endDateTime = secondEvent.startDateTime.addingTimeInterval(100)
        secondEvent.title = "A"
        syncResponse.events = .init(changed: [firstEvent, secondEvent], deleted: [], removeAllBeforeInsert: false)
        let context = EurofurenceSessionTestBuilder().with(now).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        
        let firstRealEvent = observer.upcomingEvents[0]
        let secondRealEvent = observer.upcomingEvents[1]
        
        XCTAssertEqual(firstRealEvent.identifier, EventIdentifier(secondEvent.identifier))
        XCTAssertEqual(secondRealEvent.identifier, EventIdentifier(firstEvent.identifier))
    }

}
