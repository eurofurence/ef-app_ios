import CoreData

extension EurofurenceModel {
    
    /// Fetches the `Announcement` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the announcement to be fetched.
    /// - Returns: The `Announcement` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidAnnouncement` if no `Announcement` is associated with the given identifier.
    public func announcement(identifiedBy identifier: String) throws -> Announcement {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidAnnouncement(identifier))
    }
    
    /// Fetches the `Event` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the event to be fetched.
    /// - Returns: The `Event` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidEvent` if no `Event` is associated with the given identifier.
    public func event(identifiedBy identifier: String) throws -> Event {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidEvent(identifier))
    }
    
    /// Fetches the `Dealer` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the dealer to be fetched.
    /// - Returns: The `Dealer` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidDealer` if no `Dealer` is associated with the given identifier.
    public func dealer(identifiedBy identifier: String) throws -> Dealer {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidDealer(identifier))
    }
    
    /// Fetches the `KnowledgeGroup` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the knowledge group to be fetched.
    /// - Returns: The `KnowledgeGroup` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidKnowledgeGroup` if no `KnowledgeGroup` is associated with the given identifier.
    public func knowledgeGroup(identifiedBy identifier: String) throws -> KnowledgeGroup {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidKnowledgeEntry(identifier))
    }
    
    /// Fetches the `KnowledgeEntry` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the knowledge entry to be fetched.
    /// - Returns: The `KnowledgeEntry` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidKnowledgeEntry` if no `KnowledgeEntry` is associated with the given identifier.
    public func knowledgeEntry(identifiedBy identifier: String) throws -> KnowledgeEntry {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidKnowledgeEntry(identifier))
    }
    
    /// Fetches the `Day` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the day to be fetched.
    /// - Returns: The `Day` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidDay` if no `Day` is associated with the given identifier.
    public func day(identifiedBy identifier: String) throws -> Day {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidDay(identifier))
    }
    
    /// Fetches the `Track` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the track to be fetched.
    /// - Returns: The `Track` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidTrack` if no `Track` is associated with the given identifier.
    public func track(identifiedBy identifier: String) throws -> Track {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidTrack(identifier))
    }
    
    /// Fetches the `Room` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the room to be fetched.
    /// - Returns: The `Room` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidRoom` if no `Room` is associated with the given identifier.
    public func room(identifiedBy identifier: String) throws -> Room {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidRoom(identifier))
    }
    
    /// Fetches the `Map` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the map to be fetched.
    /// - Returns: The `Map` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidMap` if no `Map` is associated with the given identifier.
    public func map(identifiedBy identifier: String) throws -> Map {
        try entity(identifiedBy: identifier, throwWhenMissing: .invalidMap(identifier))
    }
    
    /// Fetches the `Message` associated with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the message to be fetched.
    /// - Returns: The `Message` associated with the given identifier.
    /// - Throws: `EurofurenceError.invalidMessage` if no `Message` is associated with the given identifier.
    public func message(identifiedBy identifier: String) throws -> Message {
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)
        fetchRequest.fetchLimit = 1
        
        let fetchResults = try viewContext.fetch(fetchRequest)
        if let message = fetchResults.first {
            return message
        } else {
            throw EurofurenceError.invalidMessage(identifier)
        }
    }
    
    private func entity<E>(
        identifiedBy identifier: String,
        throwWhenMissing: @autoclosure () -> EurofurenceError
    ) throws -> E where E: Entity {
        let fetchRequest: NSFetchRequest<E> = E.fetchRequestForExistingEntity(identifier: identifier)
        
        let results = try viewContext.fetch(fetchRequest)
        if let entity = results.first {
            return entity
        } else {
            throw throwWhenMissing()
        }
    }
    
}
