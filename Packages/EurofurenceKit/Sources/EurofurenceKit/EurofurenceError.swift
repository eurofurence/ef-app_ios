public enum EurofurenceError: Error, Equatable {
    
    case syncFailure
    case conventionIdentifierMismatch
    case invalidAnnouncement(String)
    case invalidEvent(String)
    case invalidDealer(String)
    case invalidKnowledgeEntry(String)
    case invalidMessage(String)
    case invalidTrack(String)
    case invalidDay(String)
    
    case loginFailed
    
}
