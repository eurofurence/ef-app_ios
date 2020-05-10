import UIKit

class StoryboardEventFeedbackSceneFactory: EventFeedbackSceneFactory {
    
    private let storyboard = UIStoryboard(name: "EventFeedback", bundle: .main)
    
    func makeEventFeedbackScene() -> UIViewController & EventFeedbackScene {
        return storyboard.instantiate(EventFeedbackViewController.self)
    }
    
}
