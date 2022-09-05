public enum EurofurenceError: Error, Equatable {
    
    case syncFailure
    case conventionIdentifierMismatch
    case invalidAnnouncement(String)
    case invalidEvent(String)
    case invalidDealer(String)
    
    case loginFailed
    
}
