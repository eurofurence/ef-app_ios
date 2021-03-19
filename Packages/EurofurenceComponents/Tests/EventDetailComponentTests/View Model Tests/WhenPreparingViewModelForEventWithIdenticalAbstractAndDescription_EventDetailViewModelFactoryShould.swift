import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModelForEventWithIdenticalAbstractAndDescription_EventDetailViewModelFactoryShould: XCTestCase {

    func testNotContainDescription() {
        let event = FakeEvent.random
        event.eventDescription = event.abstract

        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()

        XCTAssertNil(visitor.visited(ofKind: EventDescriptionViewModel.self))
    }

}
