import EurofurenceModel
import Foundation

public class RemotelyConfiguredConventionStartDateRepository: ConventionStartDateRepository {
    
    private var consumers = NSHashTable<AnyObject>(options: [.weakMemory])
    private var configuration: RemoteConfiguration?
    
    private struct BlockBasedLoaderDelegate: RemoteConfigurationLoaderDelegate {
        
        var handler: (RemoteConfiguration) -> Void
        
        func remoteConfigurationLoaded(_ remoteConfiguration: RemoteConfiguration) {
            handler(remoteConfiguration)
        }
        
    }
    
    public init(remoteConfigurationLoader: RemoteConfigurationLoader) {
        let configurationLoaderDelegate = BlockBasedLoaderDelegate(handler: remoteConfigurationLoaded)
        remoteConfigurationLoader.registerConfigurationLoadedDelegate(configurationLoaderDelegate)
    }
    
    public func addConsumer(_ consumer: ConventionStartDateConsumer) {
        consumers.add(consumer)
        
        if let configuration = configuration {
            consumer.conventionStartDateDidChange(to: configuration.conventionStartDate)
        }
    }
    
    private func remoteConfigurationLoaded(_ configuration: RemoteConfiguration) {
        self.configuration = configuration
        consumers
            .allObjects
            .compactMap({ $0 as? ConventionStartDateConsumer })
            .forEach({ $0.conventionStartDateDidChange(to: configuration.conventionStartDate) })
    }
    
}
