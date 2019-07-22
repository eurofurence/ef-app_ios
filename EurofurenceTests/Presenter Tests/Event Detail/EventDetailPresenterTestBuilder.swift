@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import UIKit.UIViewController

class CapturingEventInteractionRecorder: EventInteractionRecorder {
    
    private(set) var witnessedEvent: EventIdentifier?
    func makeInteractionRecorder(for event: EventIdentifier) {
        witnessedEvent = event
    }
    
}

class EventDetailPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventDetailScene
        var hapticEngine: CapturingSelectionChangedHaptic
        var delegate: CapturingEventDetailModuleDelegate
        var eventInteractionRecorder: CapturingEventInteractionRecorder
    }

    private var interactor: EventDetailInteractor

    init() {
        interactor = DummyEventDetailInteractor()
    }

    @discardableResult
    func with(_ interactor: EventDetailInteractor) -> EventDetailPresenterTestBuilder {
        self.interactor = interactor
        return self
    }

    func build(for event: FakeEvent = .random) -> Context {
        let sceneFactory = StubEventDetailSceneFactory()
        let hapticEngine = CapturingSelectionChangedHaptic()
        let delegate = CapturingEventDetailModuleDelegate()
        let interactionRecorder = CapturingEventInteractionRecorder()
        let module = EventDetailModuleBuilder(interactor: interactor, interactionRecorder: interactionRecorder)
            .with(sceneFactory)
            .with(hapticEngine)
            .build()
            .makeEventDetailModule(for: event.identifier, delegate: delegate)

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

}
