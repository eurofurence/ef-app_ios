import EurofurenceComponentBase
import Foundation
import UIKit.UIViewController

public class EventDetailComponentBuilder {

    private let eventDetailViewModelFactory: EventDetailViewModelFactory
    private let interactionRecorder: EventInteractionRecorder
    private var sceneFactory: EventDetailSceneFactory
    private var hapticEngine: SelectionChangedHaptic

    public init(
        eventDetailViewModelFactory: EventDetailViewModelFactory,
        interactionRecorder: EventInteractionRecorder
    ) {
        self.eventDetailViewModelFactory = eventDetailViewModelFactory
        self.interactionRecorder = interactionRecorder
        
        sceneFactory = StoryboardEventDetailSceneFactory()
        hapticEngine = CocoaTouchHapticEngine()
    }

    @discardableResult
    public func with(_ sceneFactory: EventDetailSceneFactory) -> Self {
        self.sceneFactory = sceneFactory
        return self
    }

    @discardableResult
    public func with(_ hapticEngine: SelectionChangedHaptic) -> Self {
        self.hapticEngine = hapticEngine
        return self
    }

    public func build() -> EventDetailComponentFactory {
        EventDetailComponentFactoryImpl(
            sceneFactory: sceneFactory,
            eventDetailViewModelFactory: eventDetailViewModelFactory,
            hapticEngine: hapticEngine,
            interactionRecorder: interactionRecorder
        )
    }

}
