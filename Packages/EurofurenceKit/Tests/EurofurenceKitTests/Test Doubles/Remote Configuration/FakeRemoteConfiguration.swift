import EurofurenceKit

class FakeRemoteConfiguration: RemoteConfiguration {
    
    private var configuredProperties = [ObjectIdentifier: Any]()
    
    subscript <Key> (key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey {
        get {
            let id = ObjectIdentifier(key)
            return configuredProperties[id] as? Key.Value
        }
        set {
            let id = ObjectIdentifier(key)
            configuredProperties[id] = newValue
        }
    }
    
}
