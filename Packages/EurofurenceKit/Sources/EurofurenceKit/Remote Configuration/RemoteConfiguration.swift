/// A type that supplies configuration parameters to the model, fetched from a dynamic configuration.
public protocol RemoteConfiguration {
    
    /// Gets the value of the corresponding configuration key, or `nil` if there is no configured value
    /// for the given key.
    subscript <Key> (key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey { get }
    
}
