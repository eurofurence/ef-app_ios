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

    func makeAnnouncementDetailModule(for announcement: Announcement2) -> UIViewController {
        let scene = sceneFactory.makeAnnouncementDetailScene()
        scene.setAnnouncementTitle(.announcement)

        return scene
    }

}
