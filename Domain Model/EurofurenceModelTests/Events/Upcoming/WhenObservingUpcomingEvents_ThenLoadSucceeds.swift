import EurofurenceModel
import XCTest

class WhenObservingUpcomingEvents_ThenLoadSucceeds: XCTestCase {

    func testTheObserverIsProvidedWithTheUpcomingEvents() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.upcomingEvents, containsEventCharacterisedBy: randomEvent)
    }

    func testTheObserverIsNotProvidedWithEventsThatHaveBegan() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        let expectedEvents = syncResponse.events.changed.filter { (event) -> Bool in
            return event.startDateTime > simulatedTime
        }

        EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertEvents(observer.upcomingEvents, characterisedBy: expectedEvents)
    }

    func testTheObserverIsNotProvidedWithEventsTooFarIntoTheFuture() {
        let timeIntervalForUpcomingEventsSinceNow: TimeInterval = .random
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-timeIntervalForUpcomingEventsSinceNow - 1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

    func testEventsThatHaveJustStartedAreNotConsideredUpcoming() {
        let timeIntervalForUpcomingEventsSinceNow: TimeInterval = .random
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow).build()
        let observer = CapturingEventsServiceObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

}
