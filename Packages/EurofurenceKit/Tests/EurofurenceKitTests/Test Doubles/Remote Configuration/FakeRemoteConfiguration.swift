import EurofurenceWebAPI

class FakeRemoteConfiguration: RemoteConfiguration {
    
    private var configuredProperties = [ObjectIdentifier: Any]()
    
    let onChange = RemoteConfigurationChangedPublisher()
    
    subscript <Key> (key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey {
        get {
            let id = ObjectIdentifier(key)
            return configuredProperties[id] as? Key.Value
        }
        set {
            let id = ObjectIdentifier(key)
            configuredProperties[id] = newValue
            onChange.send(self)
        }
    }
    
}
