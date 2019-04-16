@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModelForEventWithIdenticalAbstractAndDescription_EventDetailInteractorShould: XCTestCase {

    func testNotContainDescription() {
        let event = FakeEvent.random
        event.eventDescription = event.abstract

        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)

        let unexpected = context.makeExpectedEventDescriptionViewModel()
        XCTAssertFalse(visitor.visitedViewModels.contains(unexpected))
    }

}
