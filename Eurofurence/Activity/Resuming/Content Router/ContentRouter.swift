import EurofurenceModel

protocol ContentRouter {
    
    func resumeViewingEvent(identifier: EventIdentifier)
    func resumeViewingDealer(identifier: DealerIdentifier)
    func resumeViewingKnowledgeGroups()
    
}
