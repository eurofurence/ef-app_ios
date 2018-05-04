//
//  AnnouncementDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

protocol AnnouncementDetailScene {

    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate)
    func setAnnouncementTitle(_ title: String)
    func setAnnouncementHeading(_ heading: String)

}

protocol AnnouncementDetailSceneDelegate {

    func announcementDetailSceneDidLoad()

}
