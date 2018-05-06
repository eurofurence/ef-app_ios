//
//  AnnouncementDetailModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import UIKit.UIViewController

struct AnnouncementDetailModule: AnnouncementDetailModuleProviding {

    var sceneFactory: AnnouncementDetailSceneFactory
    var announcementDetailInteractorFactory: AnnouncementDetailInteractorFactory

    func makeAnnouncementDetailModule(for announcement: Announcement2) -> UIViewController {
        let scene = sceneFactory.makeAnnouncementDetailScene()
        let interactor = announcementDetailInteractorFactory.makeAnnouncementDetailInteractor(for: announcement)
        _ = AnnouncementDetailPresenter(scene: scene, interactor: interactor)

        return scene
    }

}
