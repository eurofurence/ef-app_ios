import EurofurenceModel
import UIKit.UIViewController

struct EventFeedbackComponentFactoryImpl: EventFeedbackComponentFactory {
    
    var presenterFactory: EventFeedbackPresenterFactory
    var sceneFactory: EventFeedbackSceneFactory
    
    func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController {
        let scene = sceneFactory.makeEventFeedbackScene()
        presenterFactory.makeEventFeedbackPresenter(for: event, scene: scene, delegate: delegate)
        
        return scene
    }
    
}
