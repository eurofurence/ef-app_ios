@testable import Eurofurence
import EurofurenceModel
import XCTest

class WhenPreparingViewModel_EventDetailInteractorShould: XCTestCase {

    var context: EventDetailInteractorTestBuilder.Context!
    var visitor: CapturingEventDetailViewModelVisitor!

    override func setUp() {
        super.setUp()

        context = EventDetailInteractorTestBuilder().build()
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
        XCTAssertEqual(context.makeExpectedEventDescriptionViewModel(), visitor.visited(ofKind: EventDescriptionViewModel.self))
    }

}
