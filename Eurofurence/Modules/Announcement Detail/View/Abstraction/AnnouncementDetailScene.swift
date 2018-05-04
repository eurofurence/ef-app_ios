//
//  AnnouncementDetailScene.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 04/05/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation.NSAttributedString

protocol AnnouncementDetailScene {

    func setDelegate(_ delegate: AnnouncementDetailSceneDelegate)
    func setAnnouncementTitle(_ title: String)
    func setAnnouncementHeading(_ heading: String)
    func setAnnouncementContents(_ contents: NSAttributedString)

}

protocol AnnouncementDetailSceneDelegate {

    func announcementDetailSceneDidLoad()

}
