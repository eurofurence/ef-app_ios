import EurofurenceModel
import XCTest

class WhenDeletingEvent_AfterSuccessfulSync_ApplicationShould: XCTestCase {

    func testUpdateDelegateWithoutDeletedEvent() {
        var response = ModelCharacteristics.randomWithoutDeletions
        let context = EurofurenceSessionTestBuilder().build()
        let delegate = CapturingScheduleRepositoryObserver()
        context.eventsService.add(delegate)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let eventToDelete = response.events.changed.randomElement()
        response.events.changed = response.events.changed.filter({ $0.identifier != eventToDelete.element.identifier })
        let expected = Set(response.events.changed.identifiers)
        response.events.changed.removeAll()
        response.events.deleted.append(eventToDelete.element.identifier)
        context.refreshLocalStore()
        context.api.simulateSuccessfulSync(response)
        let actual = Set(delegate.allEvents.map(\.identifier.rawValue))

        XCTAssertEqual(expected, actual,
                       "Should have removed event \(eventToDelete.element.identifier)")
    }

}
