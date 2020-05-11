import EurofurenceModel
import UIKit.UIViewController

public struct EventFeedbackComponentFactoryImpl: EventFeedbackComponentFactory {
    
    public var presenterFactory: EventFeedbackPresenterFactory
    public var sceneFactory: EventFeedbackSceneFactory
    
    public init(
        presenterFactory: EventFeedbackPresenterFactory,
        sceneFactory: EventFeedbackSceneFactory
    ) {
        self.presenterFactory = presenterFactory
        self.sceneFactory = sceneFactory
    }
    
    public func makeEventFeedbackModule(
        for event: EventIdentifier,
        delegate: EventFeedbackComponentDelegate
    ) -> UIViewController {
        let scene = sceneFactory.makeEventFeedbackScene()
        presenterFactory.makeEventFeedbackPresenter(for: event, scene: scene, delegate: delegate)
        
        return scene
    }
    
}
