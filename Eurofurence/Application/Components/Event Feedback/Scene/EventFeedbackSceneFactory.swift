import UIKit.UIViewController

protocol EventFeedbackSceneFactory {
    
    func makeEventFeedbackScene() -> UIViewController & EventFeedbackScene
    
}
