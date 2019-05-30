import EurofurenceModel

protocol ResumeInteractionResponseHandler {
    
    func resumeViewingEvent(identifier: EventIdentifier)
    func resumeCollectThemAll()
    
}
