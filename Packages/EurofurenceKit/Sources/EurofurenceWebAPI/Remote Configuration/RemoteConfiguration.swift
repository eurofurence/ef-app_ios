import Combine

/// A type that supplies configuration parameters to the model, fetched from a dynamic configuration.
public protocol RemoteConfiguration {
    
    /// Exposes a Combine pipeline that emits an event when the receiver has received new values from
    /// the remote.
    var onChange: RemoteConfigurationChangedPublisher { get }
    
    /// Gets the value of the corresponding configuration key, or `nil` if there is no configured value
    /// for the given key.
    subscript <Key> (key: Key.Type) -> Key.Value? where Key: RemoteConfigurationKey { get }
    
}

/// A `Publisher` that emits an event when a `RemoteConfiguration` has changed.
public typealias RemoteConfigurationChangedPublisher = PassthroughSubject<RemoteConfiguration, Never>
