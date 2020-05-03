import EurofurenceModel
import Foundation

public struct URLContentRepresentation: ContentRepresentation {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        if url.path.contains("Events") {
            let lastPathComponent = url.lastPathComponent
            let eventIdentifier = EventIdentifier(lastPathComponent)
            let contentRepresentation = EventContentRepresentation(identifier: eventIdentifier)
            recipient.receive(contentRepresentation)
        } else if url.path.contains("Dealers") {
            let lastPathComponent = url.lastPathComponent
            let dealerIdentifier = DealerIdentifier(lastPathComponent)
            let contentRepresentation = DealerContentRepresentation(identifier: dealerIdentifier)
            recipient.receive(contentRepresentation)
        } else if url.path.contains("KnowledgeEntries") {
            let lastPathComponent = url.lastPathComponent
            let knowledgeEntryIdentifier = KnowledgeEntryIdentifier(lastPathComponent)
            let contentRepresentation = KnowledgeEntryContentRepresentation(identifier: knowledgeEntryIdentifier)
            recipient.receive(contentRepresentation)
        } else if url.path.contains("KnowledgeGroups") {
            recipient.receive(KnowledgeGroupsContentRepresentation())
        }
    }
    
}
