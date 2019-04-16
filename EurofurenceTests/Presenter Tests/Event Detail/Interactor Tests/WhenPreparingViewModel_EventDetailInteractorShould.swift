@testable import Eurofurence
import EurofurenceModel
import XCTest

class CapturingEventDetailViewModelVisitor: EventDetailViewModelVisitor {

    private(set) var visitedViewModels = [Any]()

    private(set) var visitedEventSummary: EventSummaryViewModel?
    func visit(_ summary: EventSummaryViewModel) {
        visitedViewModels.append(summary)
    }

    func visit(_ description: EventDescriptionViewModel) {
        visitedViewModels.append(description)
    }

    func visit(_ graphic: EventGraphicViewModel) {
        visitedViewModels.append(graphic)
    }

    func visit(_ sponsorsOnlyMessage: EventSponsorsOnlyWarningViewModel) {
        visitedViewModels.append(sponsorsOnlyMessage)
    }

    func visit(_ superSponsorsOnlyMessage: EventSuperSponsorsOnlyWarningViewModel) {
        visitedViewModels.append(superSponsorsOnlyMessage)
    }

    func visit(_ artShowMessage: EventArtShowMessageViewModel) {
        visitedViewModels.append(artShowMessage)
    }

    func visit(_ kageMessage: EventKageMessageViewModel) {
        visitedViewModels.append(kageMessage)
    }

    func visit(_ dealersDenMessage: EventDealersDenMessageViewModel) {
        visitedViewModels.append(dealersDenMessage)
    }

    func visit(_ mainStageMessage: EventMainStageMessageViewModel) {
        visitedViewModels.append(mainStageMessage)
    }

    func visit(_ photoshootMessage: EventPhotoshootMessageViewModel) {
        visitedViewModels.append(photoshootMessage)
    }
    
    func visit(_ actionViewModel: EventActionViewModel) {
        
    }
    
    func visited<T>(ofKind kind: T.Type) -> T? {
        return visitedViewModels.first(where: { $0 is T }) as? T
    }
    
    func index<T>(of viewModelType: T.Type) -> Int? {
        return visitedViewModels.firstIndex(where: { $0 is T })
    }
    
    func does<A, B>(_ viewModel: A.Type, precede otherViewModel: B.Type) -> Bool {
        guard let first = index(of: viewModel), let second = index(of: otherViewModel) else { return false }
        return first < second
    }
    
    func consume(contentsOf viewModel: EventDetailViewModel) {
        for index in 0...viewModel.numberOfComponents {
            viewModel.describe(componentAt: index, to: self)
        }
    }

}

class WhenPreparingViewModel_EventDetailInteractorShould: XCTestCase {

    var context: EventDetailInteractorTestBuilder.Context!
    var visitor: CapturingEventDetailViewModelVisitor!

    override func setUp() {
        super.setUp()

        context = EventDetailInteractorTestBuilder().build()
        visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: context.viewModel)
    }

    func testProduceViewModelWithExpectedNumberOfComponents() {
        XCTAssertEqual(3, context.viewModel.numberOfComponents)
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
