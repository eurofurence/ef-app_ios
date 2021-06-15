import EurofurenceClipLogic

class CapturingClipFallbackContent: ClipFallbackContent {
    
    private(set) var wasPresented = false
    func presentFallbackContent() {
        wasPresented = true
    }
    
    private(set) var preparedForShowingEvents = false
    func prepareForShowingEvents() {
        preparedForShowingEvents = true
    }
    
}
