import EurofurenceModel
import EventDetailComponent
import XCTest
import XCTEurofurenceModel

class WhenPreparingViewModel_ForEventWithKage_EventDetailViewModelFactoryShould: XCTestCase {

    func testProduceKageHeadingAfterDescriptionComponent() {
        let event = FakeEvent.randomStandardEvent
        event.isKageEvent = true
        let context = EventDetailViewModelFactoryTestBuilder().build(for: event)
        let visitor = context.prepareVisitorForTesting()
        let expected = EventKageMessageViewModel(message: "May contain traces of cockroach and wine")

        XCTAssertEqual(expected, visitor.visited(ofKind: EventKageMessageViewModel.self))
        XCTAssertTrue(visitor.does(EventKageMessageViewModel.self, precede: EventDescriptionViewModel.self))
    }

}
