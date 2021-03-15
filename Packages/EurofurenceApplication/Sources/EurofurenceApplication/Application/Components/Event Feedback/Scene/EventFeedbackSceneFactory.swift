import UIKit.UIViewController

public protocol EventFeedbackSceneFactory {
    
    func makeEventFeedbackScene() -> UIViewController & EventFeedbackScene
    
}
