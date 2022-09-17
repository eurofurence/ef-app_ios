extension APIRequests {
    
    /// A request to fetch all messages for a signed in user.
    public struct FetchMessages: APIRequest {
        
        public typealias Output = [Message]
        
        /// /// The authentication token of the current user for which messages will be fetched for.
        public let authenticationToken: AuthenticationToken
        
        public init(authenticationToken: AuthenticationToken) {
            self.authenticationToken = authenticationToken
        }
        
        public func execute(with context: APIRequestExecutionContext) async throws -> [Message] {
            let url = context.makeURL(subpath: "Communication/PrivateMessages")
            let request = NetworkRequest(url: url, method: .get, headers: [
                "Authorization": "Bearer \(authenticationToken.stringValue)"
            ])
            
            let responseData = try await context.network.perform(request: request)
            let messages = try context.decoder.decode([Message].self, from: responseData)
            
            return messages
        }
        
    }
    
}
