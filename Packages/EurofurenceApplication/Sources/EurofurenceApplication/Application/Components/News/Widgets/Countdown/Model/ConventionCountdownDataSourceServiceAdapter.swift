import Combine
import EurofurenceModel

public struct ConventionCountdownDataSourceServiceAdapter: ConventionCountdownDataSource {
    
    public let state = CurrentValueSubject<ConventionCountdown, Never>(.elapsed)
    
    public init(countdownService: ConventionCountdownService) {
        countdownService.add(UpdateCountdownWhenServiceProvidesUpdate(upstream: state))
    }
    
    private struct UpdateCountdownWhenServiceProvidesUpdate: ConventionCountdownServiceObserver {
        
        let upstream: CurrentValueSubject<ConventionCountdown, Never>
        
        func conventionCountdownStateDidChange(to state: ConventionCountdownState) {
            if case .countingDown(let days) = state {
                upstream.value = .countingDown(days: days)
            } else {
                upstream.value = .elapsed
            }
        }
        
    }
    
}
