import Eurofurence
import EurofurenceModel
import Foundation
import TestUtilities

struct StubEventSummaryViewModel: EventDetailViewModel {

    let summary: EventSummaryViewModel
    private let expectedIndex: Int

    init(summary: EventSummaryViewModel, at index: Int) {
        self.summary = summary
        expectedIndex = index
    }

    var numberOfComponents: Int = .random

    func setDelegate(_ delegate: EventDetailViewModelDelegate) {

    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(summary.randomized(ifFalse: index == expectedIndex))
    }

    func favourite() {

    }

    func unfavourite() {

    }

}
