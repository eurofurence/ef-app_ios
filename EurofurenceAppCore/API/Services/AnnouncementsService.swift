//
//  AnnouncementsService.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import Foundation

public protocol AnnouncementsService {

    func add(_ observer: AnnouncementsServiceObserver)
    func openAnnouncement(identifier: Announcement.Identifier, completionHandler: @escaping (Announcement) -> Void)
    func fetchAnnouncementImage(identifier: Announcement.Identifier, completionHandler: @escaping (Data?) -> Void)

}

public protocol AnnouncementsServiceObserver {

    func eurofurenceApplicationDidChangeAnnouncements(_ announcements: [Announcement])
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [Announcement.Identifier])

}
