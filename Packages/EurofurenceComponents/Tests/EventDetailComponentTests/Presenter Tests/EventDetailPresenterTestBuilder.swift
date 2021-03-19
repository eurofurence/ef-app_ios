import EurofurenceModel
import EventDetailComponent
import Foundation
import UIKit.UIViewController
import XCTComponentBase
import XCTEurofurenceModel
import XCTEventDetailComponent

class EventDetailPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventDetailScene
        var hapticEngine: CapturingSelectionChangedHaptic
        var delegate: CapturingEventDetailComponentDelegate
        var eventInteractionRecorder: CapturingEventInteractionRecorder
    }

    private var viewModelFactory: EventDetailViewModelFactory

    init() {
        viewModelFactory = DummyEventDetailViewModelFactory()
    }

    @discardableResult
    func with(_ viewModelFactory: EventDetailViewModelFactory) -> EventDetailPresenterTestBuilder {
        self.viewModelFactory = viewModelFactory
        return self
    }

    func build(for event: FakeEvent = .random) -> Context {
        let sceneFactory = StubEventDetailSceneFactory()
        let hapticEngine = CapturingSelectionChangedHaptic()
        let delegate = CapturingEventDetailComponentDelegate()
        let interactionRecorder = CapturingEventInteractionRecorder()
        let module = EventDetailComponentBuilder(
            eventDetailViewModelFactory: viewModelFactory,
            interactionRecorder: interactionRecorder
        )
        .with(sceneFactory)
        .with(hapticEngine)
        .build()
        .makeEventDetailComponent(for: event.identifier, delegate: delegate)
        
        return Context(
            producedViewController: module,
            scene: sceneFactory.interface,
            hapticEngine: hapticEngine,
            delegate: delegate,
            eventInteractionRecorder: interactionRecorder
        )
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
