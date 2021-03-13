import EurofurenceApplicationSession

class FakeRemoteConfigurationLoader: RemoteConfigurationLoader {
    
    private var delegate: RemoteConfigurationLoaderDelegate?
    func registerConfigurationLoadedDelegate(_ delegate: RemoteConfigurationLoaderDelegate) {
        self.delegate = delegate
    }
    
    func simulateConfigurationLoaded(_ configuration: RemoteConfiguration) {
        delegate?.remoteConfigurationLoaded(configuration)
    }
    
}
