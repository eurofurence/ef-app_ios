public protocol ConventionCountdownService {

    func add(_ observer: ConventionCountdownServiceObserver)

}

public enum ConventionCountdownState {
    case countingDown(daysUntilConvention: Int)
    case countdownElapsed
}

public protocol ConventionCountdownServiceObserver {

    func conventionCountdownStateDidChange(to state: ConventionCountdownState)

}
