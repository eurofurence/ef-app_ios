@testable import Eurofurence
import Foundation

struct StubEventFeedbackSceneFactory: EventFeedbackSceneFactory {
    
    let scene = CapturingEventFeedbackScene()
    func makeEventFeedbackScene() -> EventFeedbackScene {
        return scene
    }
    
}
