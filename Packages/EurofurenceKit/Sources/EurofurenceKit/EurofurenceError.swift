public enum EurofurenceError: Error, Equatable {
    
    case syncFailure
    case conventionIdentifierMismatch
    case invalidAnnouncement(String)
    
}
