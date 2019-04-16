@testable import Eurofurence
import Foundation
import UIKit.UIViewController

struct StubEventFeedbackSceneFactory: EventFeedbackSceneFactory {
    
    let scene = CapturingEventFeedbackScene()
    func makeEventFeedbackScene() -> UIViewController & EventFeedbackScene {
        return scene
    }
    
}
