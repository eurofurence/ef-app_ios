import Foundation

protocol RemoteConfigurationLoader {
    
    func loadRemoteConfiguration(_ completionHandler: @escaping (RemoteConfiguration) -> Void)
    
}
