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
    func openAnnouncement(identifier: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementProtocol) -> Void)
    func fetchAnnouncementImage(identifier: AnnouncementIdentifier, completionHandler: @escaping (Data?) -> Void)

}

public protocol AnnouncementsServiceObserver {

    func announcementsServiceDidChangeAnnouncements(_ announcements: [AnnouncementProtocol])
    func announcementsServiceDidUpdateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier])

}
