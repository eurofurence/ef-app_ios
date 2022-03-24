import EurofurenceModel
import XCTest

class WhenTimePasses_AndAnEventIsNoLongerUpcoming_ApplicationShould: XCTestCase {

    func testTellTheObserverTheEventIsNoLongerAnUpcomingEvent() {
        let syncResponse = ModelCharacteristics.randomWithoutDeletions
        let randomEvent = syncResponse.events.changed.randomElement().element
        var simulatedTime = randomEvent.startDateTime.addingTimeInterval(-1)
        let context = EurofurenceSessionTestBuilder().with(simulatedTime).build()
        context.performSuccessfulSync(response: syncResponse)
        let observer = CapturingScheduleRepositoryObserver()
        context.eventsService.add(observer)
        simulatedTime = randomEvent.startDateTime.addingTimeInterval(1)
        context.tickTime(to: simulatedTime)

        XCTAssertFalse(observer.upcomingEvents.contains(where: { $0.identifier.rawValue == randomEvent.identifier }))
    }

}
