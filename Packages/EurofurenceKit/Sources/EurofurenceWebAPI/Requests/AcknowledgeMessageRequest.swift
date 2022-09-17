public struct AcknowledgeMessageRequest: Hashable, APIRequest {
    
    public typealias Output = Void
    
    public var authenticationToken: AuthenticationToken
    public var messageIdentifier: String
    
    public init(authenticationToken: AuthenticationToken, messageIdentifier: String) {
        self.authenticationToken = authenticationToken
        self.messageIdentifier = messageIdentifier
    }
    
}
