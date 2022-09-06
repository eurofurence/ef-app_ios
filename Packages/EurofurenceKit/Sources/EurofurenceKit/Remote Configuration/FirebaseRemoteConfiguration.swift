public struct FirebaseRemoteConfiguration: RemoteConfiguration {
    
    public static let shared = FirebaseRemoteConfiguration()
    
    private init() {
        
    }
    
    public let onChange = RemoteConfigurationChangedPublisher()
    
    public subscript <Key> (key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey {
        nil
    }
    
}
