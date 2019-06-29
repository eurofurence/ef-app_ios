import EurofurenceModel

class RemotelyConfiguredConventionStartDateRepository: ConventionStartDateRepository {
    
    private var consumers = [ConventionStartDateConsumer]()
    private var configuration: RemoteConfiguration?
    
    init(remoteConfigurationLoader: RemoteConfigurationLoader) {
        remoteConfigurationLoader.registerConfigurationLoadedHandler(remoteConfigurationLoaded)
    }
    
    func addConsumer(_ consumer: ConventionStartDateConsumer) {
        consumers.append(consumer)
        
        if let configuration = configuration {
            consumer.conventionStartDateDidChange(to: configuration.conventionStartDate)
        }
    }
    
    private func remoteConfigurationLoaded(_ configuration: RemoteConfiguration) {
        self.configuration = configuration
        consumers.forEach({ $0.conventionStartDateDidChange(to: configuration.conventionStartDate) })
    }
    
}
