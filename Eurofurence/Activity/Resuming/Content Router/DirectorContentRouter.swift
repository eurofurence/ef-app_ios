import EurofurenceModel

struct DirectorContentRouter: ContentRouter {
    
    let director: ApplicationDirector
    
    func resumeViewingEvent(identifier: EventIdentifier) {
        director.openEvent(identifier)
    }
    
}
