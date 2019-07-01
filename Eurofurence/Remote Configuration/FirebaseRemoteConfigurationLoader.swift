import FirebaseRemoteConfig

struct FirebaseRemoteConfigurationLoader: RemoteConfigurationLoader {
    
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    func registerConfigurationLoadedDelegate(_ delegate: RemoteConfigurationLoaderDelegate) {
        ConfigFetchTask(remoteConfig: remoteConfig, completionHandler: delegate.remoteConfigurationLoaded).execute()
    }
    
    private struct ConfigFetchTask {
        
        var remoteConfig: RemoteConfig
        var completionHandler: (RemoteConfiguration) -> Void
        
        func execute() {
            remoteConfig.fetch(completionHandler: removeFetchDidFinish)
        }
        
        private func removeFetchDidFinish(_ result: RemoteConfigFetchStatus, error: Error?) {
            guard result == .success else { return }
            remoteConfig.activateFetched()
            
            guard let conventionStartTime = remoteConfig.configValue(forKey: "nextConStart").numberValue else { return }
            
            let millisToSeconds = conventionStartTime.doubleValue / 1E3
            
            let absoluteConventionStartTime = Date(timeIntervalSince1970: millisToSeconds)
            let configuration = RemoteConfiguration(conventionStartDate: absoluteConventionStartTime)
            completionHandler(configuration)
        }
        
    }
    
}
