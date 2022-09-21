import Foundation

/// Represents the remote API in which the model will collaborate with.
public protocol EurofurenceAPI {
    
    /// Asynchronously performs a request against the API, optionally returning the result of the request.
    /// - Parameter request: An `APIRequest` to execute against the API.
    /// - Returns: The resultant output of the inbound `request`.
    func execute<Request>(request: Request) async throws -> Request.Output where Request: APIRequest
    
    /// Constructs a URL for locating the associated content, bound to the scope of the API.
    ///
    /// The produced URL can be used to explicitly reference a piece of content made available through the API between
    /// application instances and platforms, e.g. cross-platform sharing or deep linking.
    ///
    /// - Parameter content: The `EurofurenceContent` to acquire a `URL` for.
    /// - Returns: A `URL` that can be used to locate the content through the API.
    func url(for content: EurofurenceContent) -> URL

}
