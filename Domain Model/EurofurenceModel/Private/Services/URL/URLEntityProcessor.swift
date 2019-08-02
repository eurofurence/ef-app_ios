import Foundation

struct URLEntityProcessor {
    
    var eventsService: EventsService
    var dealersService: DealersService
    var dataStore: DataStore
    
    func process(_ url: URL, visitor: URLContentVisitor) {
        let identifierComponent = url.lastPathComponent
        
        let eventIdentifier = EventIdentifier(identifierComponent)
        if eventsService.fetchEvent(identifier: eventIdentifier) != nil {
            visitor.visit(EventIdentifier(identifierComponent))
        }
        
        let dealerIdentifier = DealerIdentifier(identifierComponent)
        if dealersService.fetchDealer(for: dealerIdentifier) != nil {
            visitor.visit(dealerIdentifier)
        }
        
        if url.absoluteString.localizedCaseInsensitiveContains("KnowledgeGroups") {
            visitor.visitKnowledgeGroups()
        }
        
        if url.absoluteString.localizedCaseInsensitiveContains("KnowledgeEntries") {
            guard let entry = dataStore.fetchKnowledgeEntries()?.first(where: { $0.identifier == identifierComponent }) else { return }
            
            let entryIdentifier = KnowledgeEntryIdentifier(entry.identifier)
            let groupIdentifier = KnowledgeGroupIdentifier(entry.groupIdentifier)
            visitor.visitKnowledgeEntry(entryIdentifier, containedWithinGroup: groupIdentifier)
        }
    }
    
}
