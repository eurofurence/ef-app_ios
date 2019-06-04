import EurofurenceModel

struct NavigateToContentResumeInteractionResponseHandler: ResumeInteractionResponseHandler {
    
    let director: ApplicationDirector
    
    func resumeViewingEvent(identifier: EventIdentifier) {
        director.openEvent(identifier)
    }
    
}
