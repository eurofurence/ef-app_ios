import EurofurenceModel

public class StubConventionCountdownService: ConventionCountdownService {

    fileprivate var observers = [ConventionCountdownServiceObserver]()
    public fileprivate(set) var countdownState: ConventionCountdownState

    public init(countdownState: ConventionCountdownState = .countingDown(daysUntilConvention: .random)) {
        self.countdownState = countdownState
    }

    public func add(_ observer: ConventionCountdownServiceObserver) {
        observer.conventionCountdownStateDidChange(to: countdownState)
        observers.append(observer)
    }

}

extension StubConventionCountdownService {

    public func changeDaysUntilConvention(to days: Int) {
        countdownState = .countingDown(daysUntilConvention: days)
        observers.forEach({ $0.conventionCountdownStateDidChange(to: countdownState) })
    }

}
