import Foundation

struct URLEntityProcessor {
    
    var eventsService: EventsService
    var dealersService: DealersService
    
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
    }
    
}
