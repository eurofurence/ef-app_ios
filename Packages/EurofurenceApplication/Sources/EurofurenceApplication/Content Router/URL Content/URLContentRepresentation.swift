import ComponentBase
import DealerComponent
import EurofurenceModel
import Foundation

public struct URLContentRepresentation: ContentRepresentation {
    
    private static var decodingChain: URLDecodingChain = {
        var chain = URLDecodingChain()
        chain.add(DecodeContentFromURL<EventContentRepresentation>())
        chain.add(DecodeContentFromURL<DealerContentRepresentation>())
        chain.add(DecodeContentFromURL<DealersContentRepresentation>())
        chain.add(DecodeContentFromURL<KnowledgeEntryContentRepresentation>())
        chain.add(DecodeContentFromURL<KnowledgeGroupsContentRepresentation>())
        
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
