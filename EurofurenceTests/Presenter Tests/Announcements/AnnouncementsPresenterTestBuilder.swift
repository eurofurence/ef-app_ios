//
//  AnnouncementsPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import EurofurenceAppCore
import EurofurenceAppCoreTestDoubles
import UIKit

class CapturingAnnouncementsModuleDelegate: AnnouncementsModuleDelegate {
    
    private(set) var capturedSelectedAnnouncement: Announcement2.Identifier?
    func announcementsModuleDidSelectAnnouncement(_ announcement: Announcement2.Identifier) {
        capturedSelectedAnnouncement = announcement
    }
    
}

class AnnouncementsPresenterTestBuilder {
    
    struct Context {
        var scene: CapturingAnnouncementsScene
        var producedViewController: UIViewController
        var delegate: CapturingAnnouncementsModuleDelegate
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
        let delegate = CapturingAnnouncementsModuleDelegate()
        let module = AnnouncementsModuleBuilder()
            .with(sceneFactory)
            .with(announcementsInteractor)
            .build()
            .makeAnnouncementsModule(delegate)
        
        return Context(scene: sceneFactory.scene, producedViewController: module, delegate: delegate)
    }
    
}

extension AnnouncementsPresenterTestBuilder.Context {
    
    func simulateSceneDidLoad() {
        scene.delegate?.announcementsSceneDidLoad()
    }
    
    func simulateSceneDidSelectAnnouncement(at index: Int) {
        scene.delegate?.announcementsSceneDidSelectAnnouncement(at: index)
    }
    
    func bindAnnouncement(at index: Int) -> CapturingAnnouncementComponent {
        let component = CapturingAnnouncementComponent()
        scene.binder?.bind(component, at: index)
        return component
    }
    
}
