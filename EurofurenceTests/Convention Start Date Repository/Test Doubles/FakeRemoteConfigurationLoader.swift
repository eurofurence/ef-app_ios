@testable import Eurofurence

class FakeRemoteConfigurationLoader: RemoteConfigurationLoader {
    
    private var handler: ((RemoteConfiguration) -> Void)?
    func registerConfigurationLoadedHandler(_ handler: @escaping (RemoteConfiguration) -> Void) {
        self.handler = handler
    }
    
    func simulateConfigurationLoaded(_ configuration: RemoteConfiguration) {
        handler?(configuration)
    }
    
}
