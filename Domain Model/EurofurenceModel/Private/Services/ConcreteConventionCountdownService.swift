import EventBus
import Foundation

class ConcreteConventionCountdownService: ConventionCountdownService, ConventionStartDateConsumer {
    
    private let conventionStartDateRepository: ConventionStartDateRepository
    private let clock: Clock
    private var daysUntilConventionObservers = [ConventionCountdownServiceObserver]()
    private var conventionStartDate: Date?
    
    private var countdownState: ConventionCountdownState = .countdownElapsed {
        didSet {
            daysUntilConventionObservers.forEach({ $0.conventionCountdownStateDidChange(to: countdownState) })
        }
    }
    
    private struct RecomputeCountdownWhenSignificantTimePasses: EventConsumer {
        
        unowned let service: ConcreteConventionCountdownService
        
        init(service: ConcreteConventionCountdownService) {
            self.service = service
        }
        
        func consume(event: DomainEvent.SignificantTimePassedEvent) {
            service.refreshCountdownState()
        }
        
    }

    init(
        eventBus: EventBus,
        conventionStartDateRepository: ConventionStartDateRepository,
        clock: Clock
    ) {
        self.conventionStartDateRepository = conventionStartDateRepository
        self.clock = clock

        eventBus.subscribe(consumer: RecomputeCountdownWhenSignificantTimePasses(service: self))
        conventionStartDateRepository.addConsumer(self)
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        daysUntilConventionObservers.append(observer)
        observer.conventionCountdownStateDidChange(to: countdownState)
    }
    
    func conventionStartDateDidChange(to startDate: Date) {
        conventionStartDate = startDate
        refreshCountdownState()
    }
    
    private func refreshCountdownState() {
        guard let conventionStartDate = conventionStartDate else { return }
        
        let now = clock.currentDate.timeIntervalSince1970
        let conventionStart = conventionStartDate.timeIntervalSince1970
        let delta = max(0, conventionStart - now)
        let secondsInDay: TimeInterval = 60 * 60 * 24
        let daysRemaining = Int(delta / secondsInDay)
        
        if daysRemaining > 0 {
            countdownState = .countingDown(daysUntilConvention: daysRemaining)
        } else {
            countdownState = .countdownElapsed
        }
    }

}
