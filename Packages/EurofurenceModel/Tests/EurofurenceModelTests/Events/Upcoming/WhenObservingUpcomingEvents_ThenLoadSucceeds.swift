import EurofurenceModel
import XCTest

class WhenObservingUpcomingEvents_ThenLoadSucceeds: XCTestCase {

    func testTheObserverIsProvidedWithTheUpcomingEvents() throws {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        try EventAssertion(context: context, modelCharacteristics: syncResponse)
            .assertCollection(observer.upcomingEvents, containsEventCharacterisedBy: randomEvent)
    }

    func testTheObserverIsNotProvidedWithEventsThatHaveBegan() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)
        
        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

    func testTheObserverIsNotProvidedWithEventsTooFarIntoTheFuture() {
        let timeIntervalForUpcomingEventsSinceNow: TimeInterval = .random
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime.addingTimeInterval(-timeIntervalForUpcomingEventsSinceNow - 1)
        let context = EurofurenceSessionTestBuilder()
            .with(simulatedTime)
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
            .build()
        
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

    func testEventsThatHaveJustStartedAreNotConsideredUpcoming() {
        let timeIntervalForUpcomingEventsSinceNow: TimeInterval = .random
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        let simulatedTime = randomEvent.startDateTime
        let context = EurofurenceSessionTestBuilder()
            .with(simulatedTime)
            .with(timeIntervalForUpcomingEventsSinceNow: timeIntervalForUpcomingEventsSinceNow)
            .build()
        
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        context.performSuccessfulSync(response: syncResponse)

        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

}
