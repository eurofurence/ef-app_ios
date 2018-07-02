//
//  AnnouncementsModule.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation
import UIKit

struct AnnouncementsModule: AnnouncementsModuleProviding {

    var announcementsSceneFactory: AnnouncementsSceneFactory

    func makeAnnouncementsModule() -> UIViewController {
        let scene = announcementsSceneFactory.makeAnnouncementsScene()
        scene.setAnnouncementsTitle(.announcements)

        return scene
    }

}
