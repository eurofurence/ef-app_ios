@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import XCTest

class WhenPreparingViewModelForEventWithNoDescription_EventDetailInteractorShould: XCTestCase {

    func testNotContainDescription() {
        let event = FakeEvent.random
        event.eventDescription = ""

        let context = EventDetailInteractorTestBuilder().build(for: event)
        let visitor = CapturingEventDetailViewModelVisitor()

        if let viewModel = context.viewModel {
            (0..<viewModel.numberOfComponents).forEach({ viewModel.describe(componentAt: $0, to: visitor) })
        }

        let unexpected = context.makeExpectedEventDescriptionViewModel()
        XCTAssertFalse(visitor.visitedViewModels.contains(unexpected))
    }

}
