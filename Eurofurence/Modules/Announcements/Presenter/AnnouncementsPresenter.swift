//
//  AnnouncementsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct AnnouncementsPresenter {

    init(scene: AnnouncementsScene, interactor: AnnouncementsInteractor) {
        scene.setAnnouncementsTitle(.announcements)

        interactor.makeViewModel { (viewModel) in
            scene.bind(numberOfAnnouncements: viewModel.numberOfAnnouncements)
        }
    }

}
