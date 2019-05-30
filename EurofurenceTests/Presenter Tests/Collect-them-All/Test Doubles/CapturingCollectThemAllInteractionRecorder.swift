@testable import Eurofurence

class CapturingCollectThemAllInteractionRecorder: CollectThemAllInteractionRecorder {
    
    private(set) var didRecordInteraction = false
    func recordCollectThemAllInteraction() {
        didRecordInteraction = true
    }
    
}
