//
//  AnnouncementsScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 02/07/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol AnnouncementsScene {

    func setDelegate(_ delegate: AnnouncementsSceneDelegate)
    func setAnnouncementsTitle(_ title: String)
    func bind(numberOfAnnouncements: Int, using binder: AnnouncementsBinder)

}

protocol AnnouncementsSceneDelegate {

    func announcementsSceneDidLoad()

}
