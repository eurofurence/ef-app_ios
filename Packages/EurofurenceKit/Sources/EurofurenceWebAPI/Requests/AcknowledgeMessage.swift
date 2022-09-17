extension APIRequests {
    
    /// A request to notify the API a message has been read by the user.
    public struct AcknowledgeMessage: Hashable, APIRequest {
        
        public typealias Output = Void
        
        /// The authentication token of the current user, in which the associated message is intended for.
        public var authenticationToken: AuthenticationToken
        
        /// The identifier of the message the user has read.
        public var messageIdentifier: String
        
        public init(authenticationToken: AuthenticationToken, messageIdentifier: String) {
            self.authenticationToken = authenticationToken
            self.messageIdentifier = messageIdentifier
        }
        
        public func execute(with context: APIRequestExecutionContext) async throws {
            let url = context.makeURL(subpath: "Communication/PrivateMessages/\(messageIdentifier)/Read")
            guard let bodyForSwagger = "true".data(using: .utf8) else {
                fatalError("Could not produce a data object from the Swagger body")
            }
            
            let networkRequest = NetworkRequest(url: url, body: bodyForSwagger, method: .post, headers: [
                "Authorization": "Bearer \(authenticationToken.stringValue)"
            ])
            
            try await context.network.perform(request: networkRequest)
        }
        
    }
    
}
