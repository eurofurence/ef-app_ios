import EurofurenceModel
import Foundation

class StubContentLinksService: ContentLinksService {

    private var stubbedLinkActions = [String: LinkContentLookupResult]()

    func stubContent(_ content: LinkContentLookupResult, for link: Link) {
        stubbedLinkActions[link.name] = content
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        return stubbedLinkActions[link.name]
    }
    
    enum URLContent {
        case event(EventIdentifier)
        case dealer(DealerIdentifier)
        case knowledgeGroups
        case knowledge(KnowledgeEntryIdentifier, KnowledgeGroupIdentifier)
        case knowledgeEntry(KnowledgeEntryIdentifier)
    }
    
    private var urlContent = [URL: URLContent]()
    func stub(_ content: URLContent, for url: URL) {
        urlContent[url] = content
    }
    
    func describeContent(in url: URL, toVisitor visitor: URLContentVisitor) {
        guard let content = urlContent[url] else { return }
        
        switch content {
        case .event(let event):
            visitor.visit(event)
            
        case .dealer(let dealer):
            visitor.visit(dealer)
            
        case .knowledgeGroups:
            visitor.visitKnowledgeGroups()
            
        case .knowledge(let entry, let group):
            visitor.visitKnowledgeEntry(entry, containedWithinGroup: group)
            
        case .knowledgeEntry(let entry):
            visitor.visitKnowledgeEntry(entry)
        }
    }

}
