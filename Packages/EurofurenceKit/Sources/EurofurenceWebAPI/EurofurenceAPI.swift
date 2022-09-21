import Foundation

/// Represents the remote API in which the model will collaborate with.
public protocol EurofurenceAPI {
    
    /// Asynchronously performs a request against the API, optionally returning the result of the request.
    /// - Parameter request: An `APIRequest` to execute against the API.
    /// - Returns: The resultant output of the inbound `request`.
    func execute<Request>(request: Request) async throws -> Request.Output where Request: APIRequest
    
    func url(for content: EurofurenceContent) -> URL

}

public enum EurofurenceContent: Hashable {
    
    case event(id: String)
    
}
