import Foundation

struct KnowledgeEntryImpl: KnowledgeEntry {
    
    var identifier: KnowledgeEntryIdentifier
    var title: String
    var order: Int
    var contents: String
    var links: [Link]
    var shareableURLFactory: ShareableURLFactory
    
    var contentURL: URL {
        return shareableURLFactory.makeURL(for: identifier)
    }
    
}

extension KnowledgeEntryImpl {
    
    static func fromServerModel(_ entry: KnowledgeEntryCharacteristics, shareableURLFactory: ShareableURLFactory) -> KnowledgeEntry {
        let links: [Link] = Link.fromServerModels(entry.links)
        
        return KnowledgeEntryImpl(identifier: KnowledgeEntryIdentifier(entry.identifier),
                                  title: entry.title,
                                  order: entry.order,
                                  contents: entry.text,
                                  links: links,
                                  shareableURLFactory: shareableURLFactory)
    }
    
}
