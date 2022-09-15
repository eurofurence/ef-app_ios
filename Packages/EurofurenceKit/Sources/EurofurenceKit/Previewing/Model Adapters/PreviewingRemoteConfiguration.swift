import EurofurenceWebAPI

struct PreviewingRemoteConfiguration: RemoteConfiguration {
    
    let onChange = RemoteConfigurationChangedPublisher()
    
    subscript<Key>(key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey {
        nil
    }
    
}
