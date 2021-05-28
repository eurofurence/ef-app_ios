import KnowledgeJourney

class CapturingKnowledgePresentation: KnowledgePresentation {
    
    private(set) var didShowKnowledge = false
    func showKnowledge() {
        didShowKnowledge = true
    }
    
}
