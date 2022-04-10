import Combine
import ObservedObject

public class DataSourceBackedConventionCountdownViewModel: ConventionCountdownViewModel {
    
    private var subscriptions = Set<AnyCancellable>()
    
    @Observed public private(set) var showCountdown: Bool = true
    @Observed public private(set) var countdownDescription: String?
    
    init<DataSource>(dataSource: DataSource) where DataSource: ConventionCountdownDataSource {
        dataSource
            .state
            .sink { [weak self] (countdown) in
                self?.update(from: countdown)
            }
            .store(in: &subscriptions)
    }
    
    private func update(from countdown: ConventionCountdown) {
        switch countdown {
        case .countingDown(let days):
            showCountdown = true
            countdownDescription = .daysUntilConventionMessage(days: days)
            
        case .elapsed:
            showCountdown = false
            countdownDescription = nil
        }
    }
    
}
