import EurofurenceModel
import Foundation

public struct URLContentRepresentation: ContentRepresentation {
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        if let event = EventContentRepresentation(url: url) {
            recipient.receive(event)
        } else if let dealer = DealerContentRepresentation(url: url) {
            recipient.receive(dealer)
        } else if let knowledgeEntry = KnowledgeEntryContentRepresentation(url: url) {
            recipient.receive(knowledgeEntry)
        } else if let knowledgeGroups = KnowledgeGroupsContentRepresentation(url: url) {
            recipient.receive(knowledgeGroups)
        }
    }
    
}

protocol ExpressibleByURL {
    
    init?(url: URL)
    
}

extension EventContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        if url.path.contains("Events") {
            let lastPathComponent = url.lastPathComponent
            let eventIdentifier = EventIdentifier(lastPathComponent)
            self.init(identifier: eventIdentifier)
        } else {
            return nil
        }
    }
    
}

extension DealerContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        if url.path.contains("Dealers") {
            let lastPathComponent = url.lastPathComponent
            let dealerIdentifier = DealerIdentifier(lastPathComponent)
            self.init(identifier: dealerIdentifier)
        } else {
            return nil
        }
    }
    
}

extension KnowledgeEntryContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        if url.path.contains("KnowledgeEntries") {
            let lastPathComponent = url.lastPathComponent
            let knowledgeEntryIdentifier = KnowledgeEntryIdentifier(lastPathComponent)
            self.init(identifier: knowledgeEntryIdentifier)
        } else {
            return nil
        }
    }
    
}

extension KnowledgeGroupsContentRepresentation: ExpressibleByURL {
    
    init?(url: URL) {
        guard url.path.contains("KnowledgeGroups") else { return nil }
    }
    
}
