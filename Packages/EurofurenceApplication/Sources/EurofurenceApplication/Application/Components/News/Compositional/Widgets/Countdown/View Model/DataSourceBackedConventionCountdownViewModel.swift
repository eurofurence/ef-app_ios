import Combine

public class DataSourceBackedConventionCountdownViewModel: ConventionCountdownViewModel {
    
    private var subscriptions = Set<AnyCancellable>()
    
    public var showCountdown: Bool = true
    public var countdownDescription: String?
    
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
