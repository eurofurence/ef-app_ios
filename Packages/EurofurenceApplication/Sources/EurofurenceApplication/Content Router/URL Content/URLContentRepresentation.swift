import ComponentBase
import DealerComponent
import DealersComponent
import EurofurenceModel
import EventDetailComponent
import Foundation
import KnowledgeDetailComponent
import KnowledgeGroupsComponent
import ScheduleComponent

public struct URLContentRepresentation: ContentRepresentation {
    
    private static var decodingChain: URLDecodingChain = {
        var chain = URLDecodingChain()
        chain.add(DecodeContentFromURL<EventContentRepresentation>())
        chain.add(DecodeContentFromURL<DealerContentRepresentation>())
        chain.add(DecodeContentFromURL<DealersContentRepresentation>())
        chain.add(DecodeContentFromURL<KnowledgeEntryContentRepresentation>())
        chain.add(DecodeContentFromURL<KnowledgeGroupsContentRepresentation>())
        chain.add(DecodeContentFromURL<ScheduleContentRepresentation>())
        
        return chain
    }()
    
    public var url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
}

// MARK: - ContentRepresentationDescribing

extension URLContentRepresentation: ContentRepresentationDescribing {
    
    public func describe(to recipient: ContentRepresentationRecipient) {
        Self.decodingChain.describe(url: url, to: recipient)
    }
    
}
