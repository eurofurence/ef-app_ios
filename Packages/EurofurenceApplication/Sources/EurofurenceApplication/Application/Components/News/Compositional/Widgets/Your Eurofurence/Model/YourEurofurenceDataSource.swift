import Combine

public protocol YourEurofurenceDataSource {
    
    associatedtype State: Publisher where State.Output == AuthenticatedUserSummary?, State.Failure == Never
    
    var state: State { get }
    
}
