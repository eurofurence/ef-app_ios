import Foundation

protocol RemoteConfigurationLoader {
    
    func registerConfigurationLoadedDelegate(_ delegate: RemoteConfigurationLoaderDelegate)
    
}

protocol RemoteConfigurationLoaderDelegate {
    
    func remoteConfigurationLoaded(_ remoteConfiguration: RemoteConfiguration)
    
}
