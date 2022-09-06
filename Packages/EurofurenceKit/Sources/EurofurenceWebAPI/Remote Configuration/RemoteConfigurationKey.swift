import Foundation

/// Designates the identity of a remotely configured value published by a `RemoteConfiguration`.
public protocol RemoteConfigurationKey {
    
    /// The type of value published by the remote config for the given key.
    associatedtype Value
    
}
