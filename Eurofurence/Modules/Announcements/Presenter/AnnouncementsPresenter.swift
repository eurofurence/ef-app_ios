//
//  AnnouncementsPresenter.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

struct AnnouncementsPresenter: AnnouncementsSceneDelegate {

    private struct Binder: AnnouncementsBinder {

        var viewModel: AnnouncementsListViewModel

        func bind(_ component: AnnouncementComponent, at index: Int) {
            let announcement = viewModel.announcementViewModel(at: index)

            component.setAnnouncementTitle(announcement.title)
            component.setAnnouncementDetail(announcement.detail)

            if announcement.isRead {
                component.hideUnreadIndicator()
            } else {
                component.showUnreadIndicator()
            }
        }

    }

    private let scene: AnnouncementsScene
    private let interactor: AnnouncementsInteractor

    init(scene: AnnouncementsScene, interactor: AnnouncementsInteractor) {
        self.scene = scene
        self.interactor = interactor

        scene.setAnnouncementsTitle(.announcements)
        scene.setDelegate(self)
    }

    func announcementsSceneDidLoad() {
        interactor.makeViewModel { (viewModel) in
            self.scene.bind(numberOfAnnouncements: viewModel.numberOfAnnouncements, using: Binder(viewModel: viewModel))
        }
    }

}
