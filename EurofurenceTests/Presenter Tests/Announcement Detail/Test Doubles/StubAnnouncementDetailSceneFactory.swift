//
//  StubAnnouncementDetailSceneFactory.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

@testable import Eurofurence
import UIKit.UIViewController

class StubAnnouncementDetailSceneFactory: AnnouncementDetailSceneFactory {
    
    let stubbedScene = CapturingAnnouncementDetailScene()
    func makeAnnouncementDetailScene() -> UIViewController & AnnouncementDetailScene {
        return stubbedScene
    }
    
}
