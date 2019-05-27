import EurofurenceModel
import UIKit.UIViewController

struct EventFeedbackModuleProvidingImpl: EventFeedbackModuleProviding {
    
    var presenterFactory: EventFeedbackPresenterFactory
    var sceneFactory: EventFeedbackSceneFactory
    
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeEventFeedbackScene()
        presenterFactory.makeEventFeedbackPresenter(for: event, scene: scene, delegate: delegate)
        
        return scene
    }
    
}
