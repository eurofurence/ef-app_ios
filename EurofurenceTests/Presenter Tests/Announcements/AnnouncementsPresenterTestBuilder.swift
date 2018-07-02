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
    
    func build() -> Context {
        let sceneFactory = StubAnnouncementsSceneFactory()
        let module = AnnouncementsModuleBuilder().with(sceneFactory).build().makeAnnouncementsModule()
        
        return Context(scene: sceneFactory.scene, producedViewController: module)
    }
    
}
