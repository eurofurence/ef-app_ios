extension APIRequests {
    
    /// A request to fetch all messages for a signed in user.
    public struct FetchMessages: APIRequest {
        
        public typealias Output = [Message]
        
        /// /// The authentication token of the current user for which messages will be fetched for.
        public let authenticationToken: AuthenticationToken
        
        public init(authenticationToken: AuthenticationToken) {
            self.authenticationToken = authenticationToken
        }
        
    }
    
}
