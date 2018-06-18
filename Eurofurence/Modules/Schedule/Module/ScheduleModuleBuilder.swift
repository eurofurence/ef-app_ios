//
//  ScheduleModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 22/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit.UIViewController

class ScheduleModuleBuilder {

    private var eventsSceneFactory: ScheduleSceneFactory
    private var interactor: ScheduleInteractor
    private var hapticEngine: HapticEngine

    init() {
        struct DummyHapticEngine: HapticEngine {
            func playSelectionHaptic() {

            }
        }

        eventsSceneFactory = StoryboardScheduleSceneFactory()
        interactor = DefaultScheduleInteractor()
        hapticEngine = DummyHapticEngine()
    }

    @discardableResult
    func with(_ eventsSceneFactory: ScheduleSceneFactory) -> ScheduleModuleBuilder {
        self.eventsSceneFactory = eventsSceneFactory
        return self
    }

    @discardableResult
    func with(_ interactor: ScheduleInteractor) -> ScheduleModuleBuilder {
        self.interactor = interactor
        return self
    }

    @discardableResult
    func with(_ hapticEngine: HapticEngine) -> ScheduleModuleBuilder {
        self.hapticEngine = hapticEngine
        return self
    }

    func build() -> ScheduleModuleProviding {
        return ScheduleModule(eventsSceneFactory: eventsSceneFactory,
                              interactor: interactor,
                              hapticEngine: hapticEngine)
    }

}
