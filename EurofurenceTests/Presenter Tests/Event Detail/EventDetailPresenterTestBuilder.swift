//
//  EventDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 17/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles
import Foundation
import UIKit.UIViewController

class EventDetailPresenterTestBuilder {

    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingEventDetailScene
        var hapticEngine: CapturingHapticEngine
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
        let hapticEngine = CapturingHapticEngine()
        let module = EventDetailModuleBuilder()
            .with(sceneFactory)
            .with(interactor)
            .with(hapticEngine)
            .build()
            .makeEventDetailModule(for: event.identifier)

        return Context(producedViewController: module,
                       scene: sceneFactory.interface,
                       hapticEngine: hapticEngine)
    }

}

extension EventDetailPresenterTestBuilder.Context {

    func simulateSceneDidLoad() {
        scene.simulateSceneDidLoad()
    }

}
