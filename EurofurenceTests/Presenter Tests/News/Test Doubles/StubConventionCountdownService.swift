import EurofurenceModel

class StubConventionCountdownService: ConventionCountdownService {

    fileprivate var observers = [ConventionCountdownServiceObserver]()
    fileprivate(set) var countdownState: ConventionCountdownState

    init(countdownState: ConventionCountdownState = .countingDown(daysUntilConvention: .random)) {
        self.countdownState = countdownState
    }

    func add(_ observer: ConventionCountdownServiceObserver) {
        observer.conventionCountdownStateDidChange(to: countdownState)
        observers.append(observer)
    }

}

extension StubConventionCountdownService {

    func changeDaysUntilConvention(to days: Int) {
        countdownState = .countingDown(daysUntilConvention: days)
        observers.forEach({ $0.conventionCountdownStateDidChange(to: countdownState) })
    }

}
