import UIKit

public class StoryboardEventFeedbackSceneFactory: EventFeedbackSceneFactory {
    
    private let storyboard = UIStoryboard(name: "EventFeedback", bundle: .module)
    
    public init() {
        
    }
    
    public func makeEventFeedbackScene() -> UIViewController & EventFeedbackScene {
        return storyboard.instantiate(EventFeedbackViewController.self)
    }
    
}
