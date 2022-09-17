/// A type that represents an action against the ``EurofurenceAPI``.
public protocol APIRequest: Hashable {
    
    /// The resultant native type resolved upon successful actioning of this request.
    associatedtype Output
    
    /// Executes this request within the designated execution context bound by the current API configuration.
    /// - Parameter context: A parameter object providing the execution environment for the current request.
    /// - Returns: The resultant output of performing this request.
    func execute(with context: APIRequestExecutionContext) async throws -> Output
    
}

/// A namespace for well-defined ``APIRequest``s.
public enum APIRequests { }
