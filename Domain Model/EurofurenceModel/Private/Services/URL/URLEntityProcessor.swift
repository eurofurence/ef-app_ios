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
            let entries = dataStore.fetchKnowledgeEntries()
            let groups = dataStore.fetchKnowledgeGroups()
            guard let entry = entries?.first(where: { $0.identifier == identifierComponent }),
                  let group = groups?.first(where: { $0.identifier == entry.groupIdentifier }),
                  let numberOfEntriesInGroup = entries?.filter({ $0.groupIdentifier == group.identifier }).count else {
                    return
            }
            
            let entryIdentifier = KnowledgeEntryIdentifier(entry.identifier)
            if numberOfEntriesInGroup == 1 {
                visitor.visitKnowledgeEntry(entryIdentifier)
            } else {
                let groupIdentifier = KnowledgeGroupIdentifier(entry.groupIdentifier)
                visitor.visitKnowledgeEntry(entryIdentifier, containedWithinGroup: groupIdentifier)   
            }
        }
    }
    
}
