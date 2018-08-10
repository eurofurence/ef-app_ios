//
//  AnnouncementsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

protocol AnnouncementsService {

    func add(_ observer: AnnouncementsServiceObserver)
    func openAnnouncement(identifier: Announcement2.Identifier, completionHandler: @escaping (Announcement2) -> Void)
    func fetchAnnouncementImage(identifier: Announcement2.Identifier, completionHandler: @escaping (Data?) -> Void)

}

protocol AnnouncementsServiceObserver {

    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement2])
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [Announcement2.Identifier])

}
