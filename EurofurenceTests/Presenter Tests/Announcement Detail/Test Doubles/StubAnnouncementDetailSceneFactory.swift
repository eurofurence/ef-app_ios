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
    
    let stubbedScene = UIViewController()
    func makeAnnouncementDetailScene() -> UIViewController {
        return stubbedScene
    }
    
}
