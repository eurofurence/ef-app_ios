import EurofurenceClipLogic

class CapturingClipFallbackContent: ClipContentScene {
    
    private(set) var preparedForShowingEvents = false
    func prepareForShowingEvents() {
        preparedForShowingEvents = true
    }
    
    private(set) var preparedForShowingDealers = false
    func prepareForShowingDealers() {
        preparedForShowingDealers = true
    }
    
}
