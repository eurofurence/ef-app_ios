//
//  AnnouncementDetailPresenterTestBuilder.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class AnnouncementDetailPresenterTestBuilder {
    
    struct Context {
        var announcementDetailScene: UIViewController
        var sceneFactory: StubAnnouncementDetailSceneFactory
    }
    
    func build() -> Context {
        let sceneFactory = StubAnnouncementDetailSceneFactory()
        let module = AnnouncementDetailModuleBuilder().with(sceneFactory).build().makeAnnouncementDetailModule(for: Announcement2.random)
        
        return Context(announcementDetailScene: module,
                       sceneFactory: sceneFactory)
    }
    
}
