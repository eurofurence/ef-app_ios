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
    var announcementsInteractor: AnnouncementsInteractor

    func makeAnnouncementsModule(_ delegate: AnnouncementsModuleDelegate) -> UIViewController {
        let scene = announcementsSceneFactory.makeAnnouncementsScene()
        _ = AnnouncementsPresenter(scene: scene, interactor: announcementsInteractor, delegate: delegate)

        return scene
    }

}
