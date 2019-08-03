import Foundation

struct KnowledgeEntryImpl: KnowledgeEntry {
    
    var identifier: KnowledgeEntryIdentifier
    var title: String
    var order: Int
    var contents: String
    var links: [Link]
    
    func makeContentURL() -> URL {
        return unwrap(URL(string: "https://app.eurofurence.org"))
    }
    
}

extension KnowledgeEntryImpl {
    
    static func fromServerModel(_ entry: KnowledgeEntryCharacteristics) -> KnowledgeEntry {
        let links: [Link] = Link.fromServerModels(entry.links)
        
        return KnowledgeEntryImpl(identifier: KnowledgeEntryIdentifier(entry.identifier),
                                  title: entry.title,
                                  order: entry.order,
                                  contents: entry.text,
                                  links: links)
    }
    
}
