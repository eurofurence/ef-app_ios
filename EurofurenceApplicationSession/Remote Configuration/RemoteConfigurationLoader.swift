import Foundation

public protocol RemoteConfigurationLoader {
    
    func registerConfigurationLoadedDelegate(_ delegate: RemoteConfigurationLoaderDelegate)
    
}

public protocol RemoteConfigurationLoaderDelegate {
    
    func remoteConfigurationLoaded(_ remoteConfiguration: RemoteConfiguration)
    
}
