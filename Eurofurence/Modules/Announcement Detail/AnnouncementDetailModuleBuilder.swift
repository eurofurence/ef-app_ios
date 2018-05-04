//
//  AnnouncementDetailModuleBuilder.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

class AnnouncementDetailModuleBuilder {

    private var sceneFactory: AnnouncementDetailSceneFactory

    init() {
        struct DummyAnnouncementDetailSceneFactory: AnnouncementDetailSceneFactory {
            func makeAnnouncementDetailScene() -> UIViewController {
                return UIViewController()
            }
        }

        sceneFactory = DummyAnnouncementDetailSceneFactory()
    }

    @discardableResult
    func with(_ sceneFactory: AnnouncementDetailSceneFactory) -> AnnouncementDetailModuleBuilder {
        self.sceneFactory = sceneFactory
        return self
    }

    func build() -> AnnouncementDetailModuleProviding {
        return AnnouncementDetailModule(sceneFactory: sceneFactory)
    }

}
