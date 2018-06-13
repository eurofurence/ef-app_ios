//
//  SchedulePresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 23/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class SchedulePresenterTestBuilder {
    
    struct Context {
        var producedViewController: UIViewController
        var scene: CapturingScheduleScene
    }
    
    private var interactor: ScheduleInteractor
    
    init() {
        interactor = FakeScheduleInteractor()
    }
    
    @discardableResult
    func with(_ interactor: ScheduleInteractor) -> SchedulePresenterTestBuilder {
        self.interactor = interactor
        return self
    }
    
    func build() -> Context {
        let sceneFactory = StubScheduleSceneFactory()
        let viewController = ScheduleModuleBuilder().with(sceneFactory).with(interactor).build().makeScheduleModule()
        
        return Context(producedViewController: viewController, scene: sceneFactory.scene)
    }
    
}

extension SchedulePresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.scheduleSceneDidLoad()
    }
    
    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
        scene.binder?.bind(header, forGroupAt: index)
    }
    
}
