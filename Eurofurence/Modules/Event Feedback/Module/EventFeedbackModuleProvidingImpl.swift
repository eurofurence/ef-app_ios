import EurofurenceModel
import UIKit.UIViewController

struct EventFeedbackModuleProvidingImpl: EventFeedbackModuleProviding {
    
    private let presenterFactory: EventFeedbackPresenterFactory
    private let sceneFactory: EventFeedbackSceneFactory
    
    init() {
        let presenterFactory = EventFeedbackPresenterFactoryImpl(eventService: SharedModel.instance.services.events,
                                                                 dayOfWeekFormatter: FoundationDayOfWeekFormatter.shared,
                                                                 startTimeFormatter: FoundationHoursDateFormatter.shared,
                                                                 endTimeFormatter: FoundationHoursDateFormatter.shared,
                                                                 successHaptic: CocoaTouchSuccessHaptic(),
                                                                 failureHaptic: CocoaTouchFailureHaptic(),
                                                                 successWaitingRule: ShortDelayEventFeedbackSuccessWaitingRule())
        let sceneFactory = StoryboardEventFeedbackSceneFactory()
        self.init(presenterFactory: presenterFactory, sceneFactory: sceneFactory)
    }
    
    init(presenterFactory: EventFeedbackPresenterFactory, sceneFactory: EventFeedbackSceneFactory) {
        self.presenterFactory = presenterFactory
        self.sceneFactory = sceneFactory
    }
    
    func makeEventFeedbackModule(for event: EventIdentifier, delegate: EventFeedbackModuleDelegate) -> UIViewController {
        let scene = sceneFactory.makeEventFeedbackScene()
        presenterFactory.makeEventFeedbackPresenter(for: event, scene: scene, delegate: delegate)
        
        return scene
    }
    
}
