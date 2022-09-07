public struct AcknowledgeMessageRequest: Hashable {
    
    public var authenticationToken: AuthenticationToken
    public var messageIdentifier: String
    
    public init(authenticationToken: AuthenticationToken, messageIdentifier: String) {
        self.authenticationToken = authenticationToken
        self.messageIdentifier = messageIdentifier
    }
    
}
