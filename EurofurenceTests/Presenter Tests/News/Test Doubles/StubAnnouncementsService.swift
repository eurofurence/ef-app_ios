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

    var announcements: [AnnouncementProtocol]
    var stubbedReadAnnouncements: [AnnouncementIdentifier]

    init(announcements: [AnnouncementProtocol], stubbedReadAnnouncements: [AnnouncementIdentifier] = []) {
        self.announcements = announcements
        self.stubbedReadAnnouncements = stubbedReadAnnouncements
    }

    fileprivate var observers = [AnnouncementsServiceObserver]()
    func add(_ observer: AnnouncementsServiceObserver) {
        observers.append(observer)
        observer.announcementsServiceDidChangeAnnouncements(announcements)
        observer.announcementsServiceDidUpdateReadAnnouncements(stubbedReadAnnouncements)
    }

    func openAnnouncement(identifier: AnnouncementIdentifier, completionHandler: @escaping (AnnouncementProtocol) -> Void) {
        guard let announcement = announcements.first(where: { $0.identifier == identifier }) else { return }
        completionHandler(announcement)
    }

    func fetchAnnouncementImage(identifier: AnnouncementIdentifier, completionHandler: @escaping (Data?) -> Void) {
        completionHandler(stubbedAnnouncementImageData(for: identifier))
    }

}

extension StubAnnouncementsService {

    func updateAnnouncements(_ announcements: [AnnouncementProtocol]) {
        observers.forEach({ $0.announcementsServiceDidChangeAnnouncements(announcements) })
    }

    func updateReadAnnouncements(_ readAnnouncements: [AnnouncementIdentifier]) {
        observers.forEach({ $0.announcementsServiceDidUpdateReadAnnouncements(readAnnouncements) })
    }

    func stubbedAnnouncementImageData(for announcement: AnnouncementIdentifier) -> Data {
        return announcement.rawValue.data(using: .utf8)!
    }

}
