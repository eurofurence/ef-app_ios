import EventBus
import Foundation

struct SignificantTimeObserver: SignificantTimeChangeAdapterDelegate {

    private let significantTimeChangeAdapter: SignificantTimeChangeAdapter?
    private let eventBus: EventBus

    init(significantTimeChangeAdapter: SignificantTimeChangeAdapter?, eventBus: EventBus) {
        self.significantTimeChangeAdapter = significantTimeChangeAdapter
        self.eventBus = eventBus

        significantTimeChangeAdapter?.setDelegate(self)
    }

    func significantTimeChangeDidOccur() {
        eventBus.post(DomainEvent.SignificantTimePassedEvent())
    }

}
