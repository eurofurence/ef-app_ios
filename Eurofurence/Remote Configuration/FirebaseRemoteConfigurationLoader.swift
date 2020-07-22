import FirebaseRemoteConfig

class FirebaseRemoteConfigurationLoader: RemoteConfigurationLoader {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    private var delegate: RemoteConfigurationLoaderDelegate?
    
    func registerConfigurationLoadedDelegate(_ delegate: RemoteConfigurationLoaderDelegate) {
        self.delegate = delegate
        refresh { (_) in }
    }
    
    func refresh(completionHandler: @escaping (Error?) -> Void) {
        ConfigFetchTask(remoteConfig: remoteConfig, delegate: delegate, completionHandler: completionHandler).execute()
    }
    
    private struct ConfigFetchTask {
        
        var remoteConfig: RemoteConfig
        var delegate: RemoteConfigurationLoaderDelegate?
        var completionHandler: (Error?) -> Void
        
        func execute() {
            remoteConfig.fetch(completionHandler: removeFetchDidFinish)
        }
        
        private func removeFetchDidFinish(_ result: RemoteConfigFetchStatus, error: Error?) {
            defer { completionHandler(error) }
            
            guard result == .success else { return }
            remoteConfig.activate(completion: nil)
            
            guard let conventionStartTime = remoteConfig.configValue(forKey: "nextConStart").numberValue else { return }
            
            let millisToSeconds = conventionStartTime.doubleValue / 1E3
            
            let absoluteConventionStartTime = Date(timeIntervalSince1970: millisToSeconds)
            let configuration = RemoteConfiguration(conventionStartDate: absoluteConventionStartTime)
            delegate?.remoteConfigurationLoaded(configuration)
        }
        
    }
    
}
