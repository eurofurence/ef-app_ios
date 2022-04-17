import Combine

public protocol ConventionCountdownDataSource {
    
    associatedtype State: Publisher where State.Output == ConventionCountdown, State.Failure == Never
    
    var state: State { get }
    
}

public enum ConventionCountdown: Equatable {
    
    case countingDown(days: Int)
    case elapsed
    
}
