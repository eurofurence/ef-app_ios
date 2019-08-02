import EurofurenceModel

struct DirectorContentRouter: ContentRouter {
    
    let director: ApplicationDirector
    
    func resumeViewingEvent(identifier: EventIdentifier) {
        director.openEvent(identifier)
    }
    
    func resumeViewingDealer(identifier: DealerIdentifier) {
        director.openDealer(identifier)
    }
    
    func resumeViewingKnowledgeGroups() {
        director.openKnowledgeGroups()
    }
    
    func resumeViewingKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier) {
        
    }
    
    func resumeViewingKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier, parentGroup: KnowledgeGroupIdentifier) {
        director.openKnowledgeEntry(knowledgeEntry, parentGroup: parentGroup)
    }
    
}
