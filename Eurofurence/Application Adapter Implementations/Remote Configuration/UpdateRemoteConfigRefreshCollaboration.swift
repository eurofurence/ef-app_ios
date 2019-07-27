import EurofurenceModel
import FirebaseRemoteConfig

struct UpdateRemoteConfigRefreshCollaboration: RefreshCollaboration {
    
    var remoteConfigurationLoader: FirebaseRemoteConfigurationLoader
    
    func executeCollaborativeRefreshTask(completionHandler: @escaping (Error?) -> Void) {
        remoteConfigurationLoader.refresh(completionHandler: completionHandler)
    }
    
}
