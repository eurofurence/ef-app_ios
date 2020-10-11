import Eurofurence
import EurofurenceModel
import XCTest

class WhenPreparingViewModel_EventDetailViewModelFactoryShould: XCTestCase {

    var context: EventDetailViewModelFactoryTestBuilder.Context!
    var visitor: CapturingEventDetailViewModelVisitor!

    override func setUp() {
        super.setUp()

        context = EventDetailViewModelFactoryTestBuilder().build()
        visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
    }

    func testProduceExpectedGraphicViewModelBeforeSummary() {
        XCTAssertEqual(context.makeExpectedEventGraphicViewModel(), visitor.visited(ofKind: EventGraphicViewModel.self))
        XCTAssertTrue(visitor.does(EventGraphicViewModel.self, precede: EventSummaryViewModel.self))
    }

    func testProduceExpectedSummaryViewModelBeforeDescription() {
        XCTAssertEqual(context.makeExpectedEventSummaryViewModel(), visitor.visited(ofKind: EventSummaryViewModel.self))
        XCTAssertTrue(visitor.does(EventSummaryViewModel.self, precede: EventDescriptionViewModel.self))
    }

    func testProduceExpectedDescriptionViewModelAfterSummary() {
        XCTAssertEqual(
            context.makeExpectedEventDescriptionViewModel(),
            visitor.visited(ofKind: EventDescriptionViewModel.self)
        )
    }

}
