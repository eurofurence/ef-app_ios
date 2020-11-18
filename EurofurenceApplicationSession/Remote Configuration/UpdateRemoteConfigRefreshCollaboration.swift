import EurofurenceModel
import FirebaseRemoteConfig

public struct UpdateRemoteConfigRefreshCollaboration: RefreshCollaboration {
    
    var remoteConfigurationLoader: FirebaseRemoteConfigurationLoader
    
    public init(remoteConfigurationLoader: FirebaseRemoteConfigurationLoader) {
        self.remoteConfigurationLoader = remoteConfigurationLoader
    }
    
    public func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void) {
        remoteConfigurationLoader.refresh(completionHandler: completionHandler)
    }
    
}
