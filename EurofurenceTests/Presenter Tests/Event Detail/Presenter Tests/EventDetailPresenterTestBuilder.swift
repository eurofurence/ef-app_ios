@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import UIKit.UIViewController

class CapturingInteraction: Interaction {
    
    enum State {
        case unset
        case active
        case inactive
    }
    
    private(set) var state: State = .unset
    
    func activate() {
        state = .active
    }
    
    func deactivate() {
        state = .inactive
    }
    
}

class CapturingEventInteractionRecorder: EventInteractionRecorder {
    
    private(set) var witnessedEvent: EventIdentifier?
    private(set) var currentInteraction: CapturingInteraction?
    func makeInteraction(for event: EventIdentifier) -> Interaction? {
        witnessedEvent = event
        
        let interaction = CapturingInteraction()
        currentInteraction = interaction
        
        return interaction
    }
    
}

class EventDetailPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventDetailScene
        var hapticEngine: CapturingSelectionChangedHaptic
        var delegate: CapturingEventDetailComponentDelegate
        var eventInteractionRecorder: CapturingEventInteractionRecorder
    }

    private var interactor: EventDetailViewModelFactory

    init() {
        interactor = DummyEventDetailViewModelFactory()
    }

    @discardableResult
    func with(_ interactor: EventDetailViewModelFactory) -> EventDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build(for event: FakeEvent = .random) -> Context {
        let sceneFactory = StubEventDetailSceneFactory()
        let hapticEngine = CapturingSelectionChangedHaptic()
        let delegate = CapturingEventDetailComponentDelegate()
        let interactionRecorder = CapturingEventInteractionRecorder()
        let module = EventDetailComponentBuilder(eventDetailViewModelFactory: interactor, interactionRecorder: interactionRecorder)
            .with(sceneFactory)
            .with(hapticEngine)
            .build()
            .makeEventDetailComponent(for: event.identifier, delegate: delegate)

        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       hapticEngine: hapticEngine,
                       delegate: delegate,
                       eventInteractionRecorder: interactionRecorder)
    }

}

extension EventDetailPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.simulateSceneDidLoad()
    }
    
    func simulateSceneDidAppear() {
        scene.simulateSceneDidAppear()
    }
    
    func simulateSceneDidDisappear() {
        scene.simulateSceneDidDisappear()
    }

}
