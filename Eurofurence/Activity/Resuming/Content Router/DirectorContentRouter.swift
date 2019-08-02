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
    
}
