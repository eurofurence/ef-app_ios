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
        var delegate: CapturingScheduleModuleDelegate
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
        let delegate = CapturingScheduleModuleDelegate()
        let viewController = ScheduleModuleBuilder().with(sceneFactory).with(interactor).build().makeScheduleModule(delegate)
        
        return Context(producedViewController: viewController, scene: sceneFactory.scene, delegate: delegate)
    }
    
}

extension SchedulePresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.scheduleSceneDidLoad()
    }
    
    func simulateSceneDidSelectEvent(at indexPath: IndexPath) {
        scene.delegate?.scheduleSceneDidSelectEvent(at: indexPath)
    }
    
    func simulateSceneDidSelectDay(at index: Int) {
        scene.delegate?.scheduleSceneDidSelectDay(at: index)
    }
    
    func simulateSceneDidUpdateSearchQuery(_ query: String) {
        scene.delegate?.scheduleSceneDidUpdateSearchQuery(query)
    }
    
    func bind(_ header: ScheduleEventGroupHeader, forGroupAt index: Int) {
        scene.binder?.bind(header, forGroupAt: index)
    }
    
    func bind(_ eventComponent: ScheduleEventComponent, forEventAt indexPath: IndexPath) {
        scene.binder?.bind(eventComponent, forEventAt: indexPath)
    }
    
    func bind(_ dayComponent: ScheduleDayComponent, forDayAt index: Int) {
        scene.daysBinder?.bind(dayComponent, forDayAt: index)
    }
    
}
