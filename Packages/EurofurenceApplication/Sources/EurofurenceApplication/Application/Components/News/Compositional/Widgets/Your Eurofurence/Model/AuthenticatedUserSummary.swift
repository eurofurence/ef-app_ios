public struct AuthenticatedUserSummary: Equatable {
    
    public var regNumber: Int
    public var username: String
    public var unreadMessageCount: Int
    
    public init(regNumber: Int, username: String, unreadMessageCount: Int) {
        self.regNumber = regNumber
        self.username = username
        self.unreadMessageCount = unreadMessageCount
    }
    
}
