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
        
    }
    
}
