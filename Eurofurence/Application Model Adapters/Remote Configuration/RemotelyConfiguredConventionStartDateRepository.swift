import EurofurenceModel

class RemotelyConfiguredConventionStartDateRepository: ConventionStartDateRepository {
    
    private var consumers = [ConventionStartDateConsumer]()
    private var configuration: RemoteConfiguration?
    
    private struct BlockBasedLoaderDelegate: RemoteConfigurationLoaderDelegate {
        
        var handler: (RemoteConfiguration) -> Void
        
        func remoteConfigurationLoaded(_ remoteConfiguration: RemoteConfiguration) {
            handler(remoteConfiguration)
        }
        
    }
    
    init(remoteConfigurationLoader: RemoteConfigurationLoader) {
        let configurationLoaderDelegate = BlockBasedLoaderDelegate(handler: remoteConfigurationLoaded)
        remoteConfigurationLoader.registerConfigurationLoadedDelegate(configurationLoaderDelegate)
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
