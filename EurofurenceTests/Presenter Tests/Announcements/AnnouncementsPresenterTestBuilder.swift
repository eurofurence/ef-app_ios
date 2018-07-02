//
//  AnnouncementsPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit

class AnnouncementsPresenterTestBuilder {
    
    struct Context {
        var scene: CapturingAnnouncementsScene
        var producedViewController: UIViewController
    }
    
    private var announcementsInteractor: AnnouncementsInteractor
    
    init() {
        announcementsInteractor = FakeAnnouncementsInteractor()
    }
    
    @discardableResult
    func with(_ announcementsInteractor: AnnouncementsInteractor) -> AnnouncementsPresenterTestBuilder {
        self.announcementsInteractor = announcementsInteractor
        return self
    }
    
    func build() -> Context {
        let sceneFactory = StubAnnouncementsSceneFactory()
        let module = AnnouncementsModuleBuilder()
            .with(sceneFactory)
            .with(announcementsInteractor)
            .build()
            .makeAnnouncementsModule()
        
        return Context(scene: sceneFactory.scene, producedViewController: module)
    }
    
}

extension AnnouncementsPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.announcementsSceneDidLoad()
    }
    
    func bindAnnouncement(at index: Int) -> CapturingAnnouncementComponent {
        let component = CapturingAnnouncementComponent()
        scene.binder?.bind(component, at: index)
        return component
    }
    
}
