//
//  AnnouncementDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct AnnouncementDetailPresenter {

    init(scene: AnnouncementDetailScene, interactor: AnnouncementDetailInteractor) {
        scene.setAnnouncementTitle(.announcement)
        interactor.makeViewModel { (viewModel) in
            scene.setAnnouncementHeading(viewModel.heading)
            scene.setAnnouncementContents(viewModel.contents)
        }
    }

}
