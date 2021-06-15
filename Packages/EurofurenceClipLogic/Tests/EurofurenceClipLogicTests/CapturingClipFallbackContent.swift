import EurofurenceClipLogic

class CapturingClipFallbackContent: ClipFallbackContent {
    
    private(set) var wasPresented = false
    func presentFallbackContent() {
        wasPresented = true
    }
    
}
