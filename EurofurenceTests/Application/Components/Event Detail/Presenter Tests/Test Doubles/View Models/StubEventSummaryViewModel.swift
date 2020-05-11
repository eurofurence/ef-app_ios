import Eurofurence
import EurofurenceModel
import Foundation
import TestUtilities

struct StubEventSummaryViewModel: EventDetailViewModel {

    let summary: EventSummaryViewModel

    init(summary: EventSummaryViewModel) {
        self.summary = summary
    }

    var numberOfComponents: Int = .random

    func setDelegate(_ delegate: EventDetailViewModelDelegate) {

    }

    func describe(componentAt index: Int, to visitor: EventDetailViewModelVisitor) {
        visitor.visit(summary)
    }

    func favourite() {

    }

    func unfavourite() {

    }

}
