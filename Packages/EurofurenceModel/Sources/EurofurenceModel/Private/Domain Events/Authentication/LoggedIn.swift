extension DomainEvent {

    struct LoggedIn {
        
        var user: User
        var authenticationToken: String
        
    }

}
