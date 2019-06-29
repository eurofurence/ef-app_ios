import Foundation

protocol RemoteConfigurationLoader {
    
    func registerConfigurationLoadedHandler(_ handler: @escaping (RemoteConfiguration) -> Void)
    
}
