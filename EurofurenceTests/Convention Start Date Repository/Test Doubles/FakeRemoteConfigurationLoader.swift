@testable import Eurofurence

class FakeRemoteConfigurationLoader: RemoteConfigurationLoader {
    
    private var completionHandler: ((RemoteConfiguration) -> Void)?
    func loadRemoteConfiguration(_ completionHandler: @escaping (RemoteConfiguration) -> Void) {
        self.completionHandler = completionHandler
    }
    
    func simulateLoadFinished(_ configuration: RemoteConfiguration) {
        completionHandler?(configuration)
    }
    
}
