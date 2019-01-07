//
//  StubAnnouncementsService.swift
//  EurofurenceTests
//
//  Created by Thomas Sherwood on 24/04/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EurofurenceModel
import Foundation

class StubAnnouncementsService: AnnouncementsService {

    var announcements: [Announcement]
    var stubbedReadAnnouncements: [AnnouncementIdentifier]

    init(announcements: [Announcement], stubbedReadAnnouncements: [AnnouncementIdentifier] = []) {
        self.announcements = announcements
        self.stubbedReadAnnouncements = stubbedReadAnnouncements
    }

    fileprivate var observers = [AnnouncementsServiceObserver]()
    func add(_ observer: AnnouncementsServiceObserver) {
        observers.append(observer)
        observer.eurofurenceApplicationDidChangeAnnouncements(announcements)
        observer.announcementsServiceDidUpdateReadAnnouncements(stubbedReadAnnouncements)
    }

    func openAnnouncement(identifier: AnnouncementIdentifier, completionHandler: @escaping (Announcement) -> Void) {
        guard let announcement = announcements.first(where: { $0.identifier == identifier }) else { return }
        completionHandler(announcement)
    }

    func fetchAnnouncementImage(identifier: AnnouncementIdentifier, completionHandler: @escaping (Data?) -> Void) {
        completionHandler(stubbedAnnouncementImageData(for: identifier))
    }

}

extension StubAnnouncementsService {

    func updateAnnouncements(_ announcements: [Announcement]) {
        observers.forEach({ $0.eurofurenceApplicationDidChangeAnnouncements(announcements) })
    }

    func updateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        observers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncements) })
    }

    func stubbedAnnouncementImageData(for announcement: AnnouncementIdentifier) -> Data {
        return announcement.rawValue.data(using: .utf8)!
    }

}
