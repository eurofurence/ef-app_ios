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
    var announcementDetailInteractor: AnnouncementDetailInteractor

    func makeAnnouncementDetailModule(for announcement: Announcement2.Identifier) -> UIViewController {
        let scene = sceneFactory.makeAnnouncementDetailScene()
        _ = AnnouncementDetailPresenter(scene: scene,
                                        interactor: announcementDetailInteractor,
                                        announcement: announcement)

        return scene
    }

}
