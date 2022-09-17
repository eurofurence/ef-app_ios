/// A type that represents an action against the ``EurofurenceAPI``.
public protocol APIRequest: Hashable {
    
    /// The resultant native type resolved upon successful actioning of this request.
    associatedtype Output
    
}

/// A namespace for well-defined ``APIRequest``s.
public enum APIRequests { }
