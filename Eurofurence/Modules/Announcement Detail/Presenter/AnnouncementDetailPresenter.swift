//
//  AnnouncementDetailPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

struct AnnouncementDetailPresenter: AnnouncementDetailSceneDelegate {

    private let scene: AnnouncementDetailScene
    private let interactor: AnnouncementDetailInteractor

    init(scene: AnnouncementDetailScene, interactor: AnnouncementDetailInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setDelegate(self)
        scene.setAnnouncementTitle(.announcement)
    }

    func announcementDetailSceneDidLoad() {
        interactor.makeViewModel(completionHandler: announcementViewModelPrepared)
    }

    private func announcementViewModelPrepared(_ viewModel: AnnouncementViewModel) {
        scene.setAnnouncementContents(viewModel.contents)
        scene.setAnnouncementHeading(viewModel.heading)
    }

}
