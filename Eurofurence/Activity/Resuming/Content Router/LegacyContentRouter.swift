import EurofurenceModel

protocol LegacyContentRouter {
    
    func resumeViewingEvent(identifier: EventIdentifier)
    func resumeViewingDealer(identifier: DealerIdentifier)
    func resumeViewingKnowledgeGroups()
    func resumeViewingKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier)
    func resumeViewingKnowledgeEntry(_ knowledgeEntry: KnowledgeEntryIdentifier, parentGroup: KnowledgeGroupIdentifier)
    
}