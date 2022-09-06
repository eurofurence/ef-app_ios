import Foundation

/// A namespace for well-defined remote configuration keys.
public enum RemoteConfigurationKeys { }

// MARK: - Convention Start Time

extension RemoteConfigurationKeys {
    
    /// The configuration key designating when the convention is due to begin.
    public struct ConventionStartTime: RemoteConfigurationKey {
        
        public typealias Value = Date
        
    }
    
}
